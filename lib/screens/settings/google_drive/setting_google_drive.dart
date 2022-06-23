//version 1.0.0+1

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import '../../../export.dart';

class HomeScreenGoogleDrive extends StatefulWidget {
  const HomeScreenGoogleDrive({Key? key}) : super(key: key);

  @override
  State<HomeScreenGoogleDrive> createState() => _HomeScreenGoogleDriveState();
}

class _HomeScreenGoogleDriveState extends State<HomeScreenGoogleDrive> {
  late ThemeData themeData;
  late FuCustomTheme customAppTheme;
  final googleSignIn = GoogleSignIn.standard(scopes: [
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ]);

  late PageController _pageController;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      //This when screen opening have selectedWidget value 3 for delete last the value doing
      context.read<SettingProvider>().getSelectedWidget(3);
    });

    _pageController = PageController();

    googleSignIn;
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    themeData = Theme.of(context);
    systemTheme(themeData);
    customAppTheme = FuCustomTheme.getCustomAppTheme();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const FuText('النسخ الإحتياطي'),
          leading: Consumer<SettingProvider>(
            builder: (context, value, child) => IconButton(
              onPressed: () {
                if (mounted) {
                  if (value.selectedWidget == 0) {
                    value.getSelectedWidget(3);
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);

                    value.currantIndex > 0 ? value.removeFromIndex() : null;
                  } else {
                    Navigator.pop(context);
                  }
                }
              },
              icon: Icon(
                value.selectedWidget == 0
                    ? Icons.close_outlined
                    : Icons.arrow_back_ios,
                color: themeData.textTheme.bodyText1!.color,
                size: 20,
              ),
            ),
          ),
        ),
        backgroundColor: FuAppTheme.isDarkMode
            ? themeData.scaffoldBackgroundColor
            : Colors.white,
        body: PageView.builder(
          itemCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemBuilder: ((context, index) {
            return CustomListBody(index: index, widgets: widgetBody[index]);
          }),
        ),
      ),
    );
  }

//------- THIS IS BODY WIDGET ---------//
  List<Widget> get widgetBody => [
        //first widget
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: 'فلنبدأ إعداد  النسخ الإحتياطي الى\n',
                style: TextStyle(
                    fontSize: 24,
                    overflow: TextOverflow.ellipsis,
                    color: FuAppTheme.isDarkMode
                        ? StyleWidget.white
                        : StyleWidget.black,
                    fontWeight: FontWeight.w500),
                children: <TextSpan>[
                  TextSpan(
                    text: '?Google Drive'.padLeft(31),
                    style: TextStyle(
                        fontSize: 19,
                        color: FuAppTheme.isDarkMode
                            ? StyleWidget.white
                            : Colors.black,
                        fontWeight: StyleWidget.fontWeight),
                  ),
                ],
              ),
            )
                .paddingOnly(top: MySize.size24!, bottom: MySize.size80!)
                .paddingBottom(0),
            customSelect(
              select: 0,
              string: "إعدادات النسخ الإحتياطي",
              img: ImagesUrl.googleDrive,
            ),
            10.height,
            customSelect(
              select: 1,
              string: "إنشاء نسخة احتياطية",
              img: ImagesUrl.folders,
            ),
            10.height,
            customSelect(
              select: 2,
              string: "تحميل نسخة احتياطية",
              img: ImagesUrl.cloudComputing,
            ),
            10.height,
            RichText(
              text: TextSpan(
                text: 'يمكنك إنشاء نسخة احتياطية لبياناتك ورفعها على \n',
                style: TextStyle(
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  color: FuAppTheme.isDarkMode
                      ? StyleWidget.white
                      : StyleWidget.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Google Drive وستعادتها بسهولة ؟'.padLeft(31),
                    style: TextStyle(
                      fontSize: 15,
                      color: FuAppTheme.isDarkMode
                          ? StyleWidget.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ).paddingOnly(top: 25, bottom: 85),
          ],
        ).paddingOnly(
          left: 20,
          right: 20,
        ),

        //next widget
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MySize.size56.toInt().height,
            RichText(
              text: TextSpan(
                text: 'إعدادت  النسخ الإحتياطي الى\n',
                style: TextStyle(
                    fontSize: 24,
                    overflow: TextOverflow.ellipsis,
                    color: FuAppTheme.isDarkMode
                        ? StyleWidget.white
                        : StyleWidget.black,
                    fontWeight: FontWeight.w500),
                children: <TextSpan>[
                  TextSpan(
                    text: '?Google Drive'.padLeft(29),
                    style: TextStyle(
                        fontSize: 19,
                        color: FuAppTheme.isDarkMode
                            ? StyleWidget.white
                            : Colors.black,
                        fontWeight: StyleWidget.fontWeight),
                  ),
                ],
              ),
            )
                .paddingOnly(top: MySize.size24!, bottom: MySize.size80!)
                .paddingBottom(0),
            rowSelectSetting(
              select: 0,
              string: "نسخ احتياطي تلقائي",
              img: ImagesUrl.backup_Automatically,
            ),
            10.height,
            rowSelectSetting(
              select: 1,
              string: "نسخ احتياطي يدوي",
              img: ImagesUrl.backup_Manually,
            ),
            10.height,
            Consumer<SettingProvider>(
              builder: (context, value, child) => RichText(
                text: TextSpan(
                  text: value.radioValue == 0
                      ? 'النسخ التلقائي \n'
                      : 'النسخ اليدوي \n',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    color: FuAppTheme.isDarkMode
                        ? StyleWidget.white
                        : StyleWidget.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: value.radioValue == 0
                          ? 'سنقوم بعمل نسخة احتياطية بشكل يومي وذالك بعد ان يتم التحقق من بعض الشروط.'
                          : ' في هذه الحالة سيجب عليك عمل نسخ احتياطي بشكل يدوي ولن يقوم النظام بإنشاء نسخة احتياطية بشكل تلقائي ولن يقوم باظهاء الإشعارات لعمل نسخة احتياطية.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: FuAppTheme.isDarkMode
                            ? StyleWidget.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ).paddingOnly(top: 25, bottom: 85),
            ),
            10.height,
          ],
        ).paddingOnly(
          left: 20,
          right: 20,
        ),
      ];

  Widget customSelect(
      {required int select, required String string, required String img}) {
    return Consumer<SettingProvider>(
      builder: (context, value, child) => InkWell(
          highlightColor: FuAppTheme.isDarkMode
              ? Colors.grey.withAlpha(1)
              : Colors.grey.shade200,
          onTap: () async {
            if (context.read<StateAuth>().checkAccount!) {
              Navigator.push(
                context,
                CostumeTransition(const SignUpScreen()),
              );
            } else {
              value.getSelectedWidget(select);
              changeSelectedWidget(
                value,
              );
            }
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(MySize.size4!)),
                border: Border.all(
                    color: value.selectedWidget == select
                        ? themeData.colorScheme.primary
                        : Colors.grey,
                    width: 1.5),
              ),
              child: Row(
                children: [
                  Image(
                          image: AssetImage(img.toString()),
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill)
                      .paddingOnly(top: 5, bottom: 5, right: 15, left: 12),
                  Text(
                    string.toString(),
                  ).expand(),
                  value.selectedWidget == select
                      ? Icon(Icons.done, color: themeData.colorScheme.primary)
                          .paddingLeft(15)
                      : Container()
                ],
              ))),
    );
  }

  //this is for get widget is selected
  changeSelectedWidget(
    SettingProvider value,
  ) {
    // if (value.currantIndex == 0) {
    if (value.selectedWidget == 0) //go to setting backup
    {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      if (value.currantIndex < widgetBody.length - 1) {
        value.changeIndex();
      }
    } else if (value.selectedWidget == 1) // create backup
    {
      ErrorResponse.awesomeDialog(
        error: "هل تريد انشاء نسخة احتياطية",
        context: context,
        color: Colors.blue,
        dialogType: DialogType.QUESTION,
        btnCancel: 'الغاء',
        btnOkOnPress: () async {
          ServicesDatabase().generateBackup().then((value) async {
            if (value == 'FJQPi+cJX+KJm8sYAsDYqw==') {
              await ErrorResponse.showToastWidget(
                  textColor: Colors.white,
                  error: 'يبدو انه لا يوجد لديك بيانات مظافة حالياً');
            } else {
              return await _uploadToHidden(
                value,
              );
            }
          });
        },
        btnCancelOnPress: () {},
      );
    } else if (value.selectedWidget ==
        2) // Navigator to page backup from google drive
    {
      Navigator.push(context, CostumeTransition(const BackupListVewScreen()));
    }
  }

  Widget rowSelectSetting({
    required int select,
    required String string,
    required String img,
  }) {
    return Consumer<SettingProvider>(
      builder: (context, value, child) => InkWell(
          highlightColor: FuAppTheme.isDarkMode
              ? Colors.grey.withAlpha(1)
              : Colors.grey.shade200,
          onTap: () async {
            _pageController.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);

            value.getSelectedWidget(3);
            await FuSharedPreferences.setString(
                'backupAutomatically', select.toString());
            value.handleValueChange();
          },
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(MySize.size4!)),
                border: Border.all(
                    color: value.radioValue == select
                        ? themeData.colorScheme.primary
                        : Colors.grey,
                    width: 1.5),
              ),
              child: Row(
                children: [
                  Image(
                          image: AssetImage(img.toString()),
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill)
                      .paddingOnly(top: 5, bottom: 5, right: 15, left: 12),
                  Text(
                    string.toString(),
                  ).expand(),
                  Radio(
                    onChanged: (int? values) async {
                      await FuSharedPreferences.setString(
                          'backupAutomatically', select.toString());
                      value.handleValueChange();
                      value.getSelectedWidget(3);
                      _pageController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                      // value.currantIndex > 0 ? value.removeFromIndex() : null;
                    },
                    groupValue: value.radioValue,
                    value: select,
                    activeColor: themeData.colorScheme.primary,
                  ).paddingLeft(15)
                ],
              ))),
    );
  }

  //--------- UPLOAD BACKUP HIDDEN TO GOOGLE DRIVE ---------//
  Future<void> _uploadToHidden(
    String? contents,
  ) async {
    var dialogContext;

    try {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext cont) {
          dialogContext = cont;
          return UtilsSettings.uploadGoogleDrive();
        },
      );

      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        return;
      }
      final Stream<List<int>> mediaStream =
          Future.value(contents!.codeUnits).asStream().asBroadcastStream();
      var media = drive.Media(mediaStream, contents.length);

      // Set up File info
      var driveFile = drive.File();
      final timestamp = DateTime.now();
      await Jiffy.locale(
          "ar"); //this is for translation date to language arabic
      final formatter = Jiffy(timestamp).yMMMMEEEEdjm;
      driveFile.name = "Issus_App-$formatter.txt";
      driveFile.modifiedTime = DateTime.now().toUtc();
      driveFile.parents = ["appDataFolder"];

      // Upload
      final response = await driveApi.files
          .create(driveFile, uploadMedia: media)
          .timeout(const Duration(minutes: 5), onTimeout: () {
        Navigator.pop(dialogContext);
        return ErrorResponse.customAwesomeDialog(
            'انتهت مدةالاتصال بالخادم', context, DialogType.WARNING);
      });
      if (response.toJson().isNotEmpty) {
        if (mounted) {
          if (dialogContext is BuildContext || dialogContext != null) {
            await ErrorResponse.showToastWidget(
                error: 'تم انشاء نسخة احتياطية بنجاح',
                colorShowToast: Colors.green);
            Navigator.pop(dialogContext!);
          }
        }
      }

      //  print("response: $response");
    } catch (e) {
      if (dialogContext is BuildContext || dialogContext != null) {
        Navigator.pop(dialogContext!);
      }

      UtilsAuth.parseError(
        e,
        context,
      );
      // print(e);
    }
  }

  // get Drive Api
  Future<drive.DriveApi?> _getDriveApi() async {
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    if (headers == null) {
      UtilsAuth.parseError('Error Sign-in first', context,
          isShowToast: true, colorShowToast: FuAppTheme.customTheme.colorError);
      return null;
    }

    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }
}
