//version 1.0.0+1
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:issue/services/google_drive/authentication/auth_manager.dart';
import 'package:issue/services/google_drive/authentication/my_client.dart';

import 'package:jiffy/jiffy.dart';
import 'package:open_file/open_file.dart';
import 'package:googleapis/docs/v1.dart' as docsV1;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/drive/v2.dart' as Api;
import 'dart:async';
import 'dart:io' as io;
import 'package:kt_dart/collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:path_provider/path_provider.dart';
import '/export.dart';

class BackupListVewScreen extends StatefulWidget {
  const BackupListVewScreen({Key? key}) : super(key: key);

  @override
  BackupListVewScreenState createState() => BackupListVewScreenState();
}

class BackupListVewScreenState extends State<BackupListVewScreen> {
  GoogleSignInAccount? _currentUser;
  List<Api.File> _items = [];
  bool _loaded = false;
  late ThemeData themeData;
  late FuCustomTheme customTheme;

  final googleSignIn = GoogleSignIn.standard(scopes: [
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ]);
  @override
  void initState() {
    super.initState();
    _signInSilently();
  }

  @override
  void dispose() {
    super.dispose();
    localJiffy();
  }

  //------------IF DELETE THIS LINE MAYBE DOING ERROR IN THE APPLICATION------------//
  localJiffy() async {
    await Jiffy.locale("en"); //this is for translation date to language english
  }

  Future<void> _signInSilently() async {
    //------------IF DELETE THIS LINE MAYBE DOING ERROR IN THE APPLICATION------------//
    await Jiffy.locale("ar"); //this is for translation date to language arabic
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      return;
    }

    var account = await AuthManager.signInSilently();
    setState(() {
      _currentUser = account;
      if (account != null) {
        _loadFiles();
      } else {
        _getDriveApi();
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    });
  }
  //--------------THIS IS FOR INTEGRATION WITH GOOGLE DRIVE----------------//

  Future<drive.DriveApi?> _getDriveApi() async {
    try {
      final googleUser = await googleSignIn.signIn();
      final headers = await googleUser?.authHeaders;
      if (headers == null) {
        UtilsAuth.parseError('Error Sign-in first', context,
            isShowToast: true, colorShowToast: customTheme.colorError);
        return null;
      }

      final client = GoogleAuthClient(headers);
      final driveApi = drive.DriveApi(client);
      return driveApi;
    } catch (e) {
    // print('debug: $e');
      if (mounted) {
        UtilsAuth.parseError(e, context,
            isShowToast: true, colorShowToast: customTheme.colorError);
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
     //  print('=======>Error $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    customTheme = FuCustomTheme();
    systemTheme(themeData);
    final loggedIn = _currentUser != null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: FuAppTheme.isDarkMode
              ? themeData.scaffoldBackgroundColor
              : Colors.white,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: FuAppTheme.isDarkMode == false
                    ? Colors.black
                    : FuAppTheme.customTheme.withe,
              ),
            ),
            backgroundColor: FuAppTheme.isDarkMode
                ? themeData.scaffoldBackgroundColor
                : Colors.white,
            title: Text(loggedIn ? _currentUser!.email : '',
                style: TextStyle(color: themeData.textTheme.bodyText1!.color)),
          ),
          body: Directionality(
            textDirection: TextDirection.ltr,
            child: RefreshIndicator(
              onRefresh: _signInSilently,
              backgroundColor: FuAppTheme.isDarkMode
                  ? themeData.scaffoldBackgroundColor
                  : Colors.white,
              child: SafeArea(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: FuAppTheme.isDarkMode
                      ? Colors.black.withAlpha(60)
                      : Colors.white,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: (loggedIn && _loaded) ? _listView : _progressLoader,
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Future<void> _loadDocument(drive.DriveApi driveApi, id) async {
    var dialogContext;
    try {
      bool check = true; //this is for open showDialog or close howDialog
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext cont) {
          dialogContext = cont;
          check != true ? Navigator.pop(cont) : Container();
          return UtilsSettings.loadingGoogleDrive();
        },
      );

      if (_currentUser == null) return;

      GoogleSignInAuthentication authentication =
          await _currentUser!.authentication;
     // print('authentication: $authentication');
      final client = MyClient(defaultHeaders: {
        'Authorization': 'Bearer ${authentication.accessToken}'
      });

      drive.Media? response1 = await driveApi.files.get(id,
          downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media?;
      final String path = (await getApplicationSupportDirectory()).path;

      final String myFileName = '$path/IssueApp.txt';
      io.File file = io.File(myFileName);
      List<int> dataStore = [];
      response1!.stream.listen(
          (data) {
          //  print("DataReceived: ${data.length}");
            dataStore.insertAll(dataStore.length, data);
          },
          cancelOnError: true,
          onDone: () async {
           // print("Task Done");
            await file.writeAsBytes(dataStore);
            OpenFile.open(file.toString());
          //print("===========> File saved at ${file.path}");
            io.File myFile = io.File(myFileName);

            String fileContent = await myFile.readAsString();
            ServicesDatabase().restoreBackup(fileContent);
            io.File(myFile.path).delete(recursive: true).then((value) {
              FuLog('========> deleted data when restoreBackup');
            }).onError((error, stackTrace) {
              FuLog(error.toString());
            });
            Navigator.pop(dialogContext);
            Navigator.pop(context);
          },
          onError: (error) {
            if (dialogContext != null) {
              Navigator.pop(dialogContext);
            } else {
              setState(
                () => check = false,
              );
            }

            UtilsAuth.parseError(
              error,
              context,
            );
          //  print("==========> Some Error");
          });
    } catch (e) {
      if (dialogContext != null) {
        Navigator.pop(dialogContext);
      }

      ErrorResponse.awesomeDialog(
        error: e.toString(),
        context: context,
        dialogType: DialogType.ERROR,
      );
    }
  }

  //----------THIS IS FOR DELETE BACKUP FROM GOOGLE DRIVE----------//
  Future<void> deleteDataFromGoogleDrive(drive.DriveApi driveApi, id) async {
    try {
      var dialogContext;
      bool check = true; //this is for open showDialog or close howDialog
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext cont) {
          dialogContext = cont;
          check != true ? Navigator.pop(cont) : Container();
          return UtilsAuth.willPopScope();
        },
      );
      if (_currentUser == null) return;

      return await driveApi.files
          .delete(id)
          .onError((error, stackTrace) => {
                ErrorResponse.awesomeDialog(
                    error: error,
                    context: context,
                    dialogType: DialogType.WARNING),
                if (mounted)
                  {
                    if (dialogContext != null) {Navigator.pop(dialogContext)}
                  }
              })
          .timeout(const Duration(minutes: 1), onTimeout: () {
        Navigator.pop(dialogContext);
        return ErrorResponse.customAwesomeDialog(
            'انتهت مدةالاتصال بالخادم', context, DialogType.WARNING);
      }).catchError((onError) {
        FuLog('=======>Error $onError');
      }).whenComplete(() async {
        if (mounted) {
          await _loadFiles();

          if (dialogContext != null) {
            if (mounted) {
              Navigator.pop(dialogContext);
              await ErrorResponse.showToastWidget(
                  error: 'تم الحذف بنجاج', colorShowToast: Colors.green);
            }
          }
        } else {
          setState(() {
            check = false;
            ErrorResponse.showToastWidget(
                error: 'تم الحذف بنجاج', colorShowToast: Colors.green);
          });
        }
      });
    } on TimeoutException catch (_) {
      await ErrorResponse.showToastWidget(
          error: 'انتهت مدة الاتصال بالخادم', colorShowToast: Colors.red);
    } catch (e) {
      await ErrorResponse.showToastWidget(
          error: e.toString(), colorShowToast: Colors.red);
    }
  }

// This ProgressLoader
  Widget get _progressLoader => Stack(
        children: const <Widget>[
          Align(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ),
            ),
          ),
        ],
      );

// This listView Date
  Widget get _listView {
    if (_items.isEmpty || _items.length < 1) {
      return const NotFoundData(error: 'لا توجد نسخة احتياطية حاليا');
    }
    final leftEditIcon = Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.green,
      ),
      child: Row(
        children: [
          const Icon(Icons.download).paddingOnly(
            left: 7,
            right: 4,
          ),
          const Text(
            'تحميل',
            style: TextStyle(
              color: Color.fromARGB(255, 240, 241, 247),
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.2,
            ),
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    );
    final rightDeleteIcon = Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.red,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const Icon(Icons.delete).paddingOnly(
            left: 9,
            right: 4,
          ),
          const Text(
            'حذف',
            style: TextStyle(
              color: Color.fromARGB(255, 240, 241, 247),
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.2,
            ),
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    );
    return Container(
      color: FuAppTheme.isDarkMode ? Colors.black.withAlpha(60) : Colors.white,
      child: ListView.separated(
        itemBuilder: (context, index) {
          _items.sort((a, b) {
            return b.createdDate!.compareTo(a.createdDate!);
          });
          var item = _items[index];
        
          final formatter = item.originalFilename
              .toString()
              .split('Issus_App-')[1]
              .split('.txt')[0];

          return Dismissible(
            key: ObjectKey(_items[index]),
            child: Container(
              decoration: BoxDecoration(
                  color: FuAppTheme.isDarkMode == false
                      ? Colors.white
                      : FuAppTheme.theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                      color: FuAppTheme.customTheme.border2, width: 1)),
              child: Card(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1.0, color: Colors.blue.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: FuAppTheme.isDarkMode == false
                    ? Colors.white
                    : FuAppTheme.theme.scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title!,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: themeData.textTheme.bodyText1!.color,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              formatter.toString(),
                              style: const TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            KtList.from(item.ownerNames!).joinToString(),
                            style: const TextStyle(
                              fontSize: 12.0,
                            ),
                          ).paddingRight(12),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.startToEnd) {
                // Left to right
                //print("Download");
              } else if (direction == DismissDirection.endToStart) {
                // Right to left
               // print("Delete");

                var deletedItem;
                setState(() {
                  deletedItem = _items.removeAt(index);
                });

                ErrorResponse.awesomeDialog(
                  error: "هل تريد حذف هذه النسخة ${item.originalFilename}",
                  context: context,
                  color: Colors.blue,
                  dialogType: DialogType.QUESTION,
                  btnCancel: 'الغاء',
                  btnOkOnPress: () async {
                    final driveApi = await _getDriveApi();
                    var account = await AuthManager.signInSilently();
                    if (account != null) {
                      await deleteDataFromGoogleDrive(driveApi!, item.id);
                    } else {
                      await ErrorResponse.showToastWidget(
                          error: 'هناك خطاءً ما',
                          colorShowToast: customTheme.colorError);
                    }
                  },
                  btnCancelOnPress: () {
                    setState(() => _items.insert(index, deletedItem));
                  },
                );
              }
            },
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                ErrorResponse.awesomeDialog(
                  error: "هل تريد تنزيل نسخة ${item.originalFilename}",
                  context: context,
                  color: Colors.blue,
                  btnCancel: 'الغاء',
                  dialogType: DialogType.QUESTION,
                  btnOkOnPress: () async {
                    final driveApi = await _getDriveApi();
                    var account = await AuthManager.signInSilently();
                    _currentUser = account;
                    if (account != null) {
                      _loadDocument(driveApi!, item.id);
                    } else {
                      await ErrorResponse.showToastWidget(
                          error: 'هناك خطاءً ما',
                          colorShowToast: customTheme.colorError);

                      FuLog('=======>Error account: null');
                    }
                  },
                  btnCancelOnPress: () {},
                );
                return false;
              } else {
                return Future.value(direction == DismissDirection.endToStart);
              }
            },
            // direction: DismissDirection.endToStart,
            background: leftEditIcon,
            secondaryBackground: rightDeleteIcon,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8.0);
        },
        itemCount: _items.length,
        padding: const EdgeInsets.all(8.0),
      ),
    );
  }

//------------- THIS IS FOR LOD DATA FROM GOOGLE DRIVE TO LOCAL FILE AND RESTORE DATA TO DATABASE------------//

  Future<void> _loadFiles() async {
    try {
      if (_currentUser == null) return;

      GoogleSignInAuthentication authentication =
          await _currentUser!.authentication;
     // print('authentication: $authentication');
      final client = MyClient(defaultHeaders: {
        'Authorization': 'Bearer ${authentication.accessToken}'
      });
      Api.DriveApi driveApi = Api.DriveApi(client);

      var files = await driveApi.files.list(
        spaces: 'appDataFolder',
      );
      if (mounted) {
        setState(() {
          _items = files.items!;
          _loaded = true;
        });
      }
    } catch (e) {
      FuLog('=======>Error $e');
      'requested';
      if (mounted) {
        await Future.delayed(const Duration(seconds: 2)).then((value) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    }
  }

  void _logout() {
    setState(() {
      _currentUser = null;
    });
    AuthManager.signOut();
    Navigator.of(context).pop();
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}
