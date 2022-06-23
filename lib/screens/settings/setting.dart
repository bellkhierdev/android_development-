//version 1.0.0

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:issue/export.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../services/local_Auth/state.dart';
import 'about/widgets.dart';

class SettingScreen extends StatefulWidget {
  final BuildContext root;

  const SettingScreen({Key? key, required this.root}) : super(key: key);

  @override
  _ShoppingProfileScreenState createState() => _ShoppingProfileScreenState();
}

class _ShoppingProfileScreenState extends State<SettingScreen> {
  dynamic resultImage;
//---- THIS IS FOR GET PATH APP DOCUMENT DIRECTORY ---- //
  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/imageProfile.jpg';

    return filePath;
  }

//---- THIS IS FOR SAVE IMAGE TO LOCAL FILE ---- //
  void saveFile() async {
    File file = File(await getFilePath());
    if (_image != null) {
      file.writeAsString(_image!.path);
      readFile();
    }
  }

//---- THIS IS FOR READ IMAGE PROFILE FROM FILE---- //
  File? readImage;
  readFile() async {
    File file = File(await getFilePath());
    String fileContent = await file.readAsString();
    setState(() {
      readImage = File(fileContent);
    });
    // print('File Content: $fileContent');
  }

  File? _image;
  final _picker = ImagePicker();
  // Implementing the image picker
  Future<dynamic> _openImagePicker() async {
    if (resultImage != null) {
      File(resultImage)
          .delete(recursive: true)
          .then((value) {})
          .onError((error, stackTrace) {});
      await FuSharedPreferences.deleteString(
        'imageProfile',
      );
    }
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      saveFile();
      await FuSharedPreferences.setString(
          'imageProfile', pickedImage.path.toString());
      setState(() {
        _image = File(pickedImage.path);
      });
    } else {
      if (resultImage == null) {
        await FuSharedPreferences.deleteString(
          'imageProfile',
        );
        setState(() {
          resultImage = null;
        });
      }
    }
  }

  getImageFromSharedPreferences() async {
    var image = await FuSharedPreferences.getString(
      'imageProfile',
    );
    setState(() {
      resultImage = image;
    });
    return resultImage;
  }

  final googleSignIn = GoogleSignIn.standard(scopes: [
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ]);

  // String username = '';
  // String typeAccount = '';

  @override
  void dispose() {
    super.dispose();
    localJiffy();
  }

  localJiffy() async {
    //------------IF DELETE THIS FUNCTION MAYBE DOING ERROR IN THE APPLICATION------------//
    await Jiffy.locale("en"); //this is for translation date to language english
  }

  @override
  void initState() {
    super.initState();

    getImageFromSharedPreferences();

    googleSignIn;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      var account = await AuthManager.signInSilently();

      if (mounted) {
        context.read<SettingProvider>().infoUserData();
      }

      if (account != null) {
        if (mounted) {
          context.read<SettingProvider>().getCurrentUser(account);
        }
      }

      await Jiffy.locale(
          "en"); //this is for translation date to language english
    });
  }

  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context); //this is for initialize ThemeData
    return Theme(
      data: FuAppTheme.theme.copyWith(
          colorScheme: FuAppTheme.theme.colorScheme.copyWith(
              secondary: FuAppTheme.theme.primaryColor.withAlpha(10))),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: FuAppTheme.isDarkMode
                ? themeData.scaffoldBackgroundColor
                : Colors.white,
            body: ListView(
              shrinkWrap: true,
              padding: FuSpacing.noTop(24),
              children: <Widget>[
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    CircleButton(
                      color: FuAppTheme.isDarkMode
                          ? StyleWidget.cardDark.withAlpha(200)
                          : Colors.grey[200],
                      onPressed: () {
                        void _handleRadioValueChange(FuAppThemeType? value) {
                          Provider.of<FuAppThemeNotifier>(context,
                                  listen: false)
                              .changeAppThemeMode(value);
                        }

                        //------ Change App ThemeMode ------//
                        FuAppTheme.isDarkMode
                            ? _handleRadioValueChange(FuAppThemeType.light)
                            : _handleRadioValueChange(FuAppThemeType.dark);
                      },
                      icon: Icon(
                        FuAppTheme.isDarkMode
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        color: FuAppTheme.customTheme.blueToWithe,
                      ),
                      iconSize: 30,
                    ),
                  ],
                ),
                FuSpacing.height(16),
                Consumer<SettingProvider>(
                  builder: (BuildContext context, value, Widget? child) {
                    return Column(
                      children: <Widget>[
                        imageProfile(),
                        FuSpacing.height(8),
                        FuText.h6(
                            value.username == null
                                ? value.currentUser!.displayName.toString()
                                : value.username!,
                            color: themeData.textTheme.bodyText1!.color,
                            fontWeight: 600,
                            letterSpacing: 0),
                      ],
                    );
                  },
                ),
                FuSpacing.height(24),
                FuContainer(
                  color: FuAppTheme.theme.colorScheme.primary,
                  padding: FuSpacing.xy(16, 8),
                  borderRadiusAll: 4,
                  child: Row(
                    children: <Widget>[
                      Icon(MdiIcons.informationOutline,
                          color: FuAppTheme.theme.colorScheme.onPrimary,
                          size: 18),
                      FuSpacing.width(16),
                      Consumer<SettingProvider>(
                        builder: (BuildContext context, value, Widget? child) =>
                            const FuText.b2('حساب نشط',
                                    color: Color(0xffFFDF00),
                                    fontWeight: 600,
                                    letterSpacing: 0.2)
                                .expand(),
                      ),
                      FuSpacing.width(16),
                      FuText.caption(
                        "حالة الحساب",
                        fontWeight: 600,
                        letterSpacing: 0.2,
                        color: FuAppTheme.theme.colorScheme.onPrimary,
                      )
                    ],
                  ),
                ),
                FuSpacing.height(24),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: <Widget>[
                      // coming soon
                      // UtilsSettings.singleOption(
                      //     iconData: MdiIcons.star,
                      //     option: "قيمنا",
                      //     navigation: null,
                      //     context: context),

                      // coming soon
                      // UtilsSettings.singleOption(
                      //     iconData: MdiIcons.heartOutline,
                      //     option: "المفضلة",
                      //     navigation: null,
                      //     context: context),

                      UtilsSettings.singleOption(
                          iconData: MdiIcons.creditCardOutline,
                          option: "من نحن",
                          navigation: const AnimationDeveloper(),
                          context: context),

                      UtilsSettings.singleOption(
                          iconData: MdiIcons.helpBox,
                          option: "عن التطبيق",
                          navigation: const MyCustomWidget(),
                          context: context),
                      // coming soon
                      // UtilsSettings.singleOption(
                      //     iconData: MdiIcons.share,
                      //     option: "مشاركة التطبيق",
                      //     navigation: null,
                      //     context: context),
                      // coming soon

                      UtilsSettings.singleOption(
                          iconData: MdiIcons.help,
                          enableOnTap: true,
                          option: "مساعدة  ",
                          navigation: null,
                          context: context),
                      UtilsSettings.singleOption(
                        iconData: MdiIcons.relativeScale,
                        option: " النسخة 1+1.0.0",
                        navigation: null,
                        context: context,
                      ),
                      Consumer<LocalAuthProvider>(
                        builder: (BuildContext context, value, child) =>
                            Container(
                          padding: FuSpacing.y(8),
                          child: InkWell(
                            onTap: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.SCALE,
                                customHeader: Icon(
                                  Icons.fingerprint,
                                  color: themeData.colorScheme.primary,
                                  size: 50.sp,
                                ),
                                dismissOnBackKeyPress: true,
                                headerAnimationLoop: false,
                                // padding: const EdgeInsets.only(right: 60, left: 60),
                                title:
                                    '${value.isFingerprint == true ? ' الغاء ' : ' تفعيل '}الحماية  عبر البصمة او العين',
                                btnOkText: value.isFingerprint == true
                                    ? ' الغاء التفعيل '
                                    : ' تفعيل ',
                                btnOkOnPress: () {
                                  if (context.read<StateAuth>().checkAccount!) {
                                    Navigator.push(
                                      context,
                                      CostumeTransition(const SignUpScreen()),
                                    );
                                  } else {
                                    value.checkLocalAuth();
                                  }
                                },
                                // btnCancelOnPress: () {},
                                // btnCancelOnPress: () {},
                                // padding: EdgeInsets.only(right: 20, left: 20),
                                btnCancelColor: Colors.grey,
                                // btnCancelText: 'الغاء',
                                // desc: 'description',
                                buttonsTextStyle: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: MySize.size16,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w700),
                                btnOkColor: value.isFingerprint == true
                                    ? Colors.redAccent
                                    : Colors.green,
                              ).show();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  MdiIcons.fingerprint,
                                  size: 22,
                                  color:
                                      FuAppTheme.theme.colorScheme.onBackground,
                                ),
                                FuSpacing.width(16),
                                FuText.b1(
                                  "الحماية عبر البصمة",
                                  fontWeight: 600,
                                  color:
                                      FuAppTheme.theme.colorScheme.onBackground,
                                ).expand(),
                                Icon(MdiIcons.chevronLeft,
                                    size: 22,
                                    color: FuAppTheme
                                        .theme.colorScheme.onBackground),
                              ],
                            ),
                          ),
                        ),
                      ),

                      UtilsSettings.singleOption(
                          iconData: MdiIcons.googleDrive,
                          option: "النسخ الإحتياطي",
                          navigation: const HomeScreenGoogleDrive(),
                          context: context),

                      FuSpacing.height(24),
                      //Logout
                      Center(
                        child: FuButton(
                            elevation: 0,
                            backgroundColor:
                                FuAppTheme.theme.colorScheme.primary,
                            borderRadiusAll: 4,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  MdiIcons.logoutVariant,
                                  color: FuAppTheme.theme.colorScheme.onPrimary,
                                  size: 18,
                                ),
                                FuSpacing.width(16),
                                FuText.caption("تسجيل خروج",
                                    letterSpacing: 0.3,
                                    fontWeight: 600,
                                    color:
                                        FuAppTheme.theme.colorScheme.onPrimary)
                              ],
                            ),
                            onPressed: () async {
                              ErrorResponse.awesomeDialog(
                                error: " هل تريد تسجيل الخروج بالفعل",
                                context: context,
                                color: Colors.red,
                                dialogType: DialogType.QUESTION,
                                btnCancel: 'الغاء',
                                btnOkOnPress: () async {
                                  UtilsSettings.logout(context);
                                },
                                btnCancelOnPress: () {},
                              );
                            }),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  // ----------- THIS IS IMAGE PROFILE WIDGET -----------  //
  imageProfile() {
    return Stack(
      children: [
        FuContainer.rounded(
            paddingAll: 0,
            width: 80,
            height: 90,
            color: FuAppTheme.isDarkMode
                ? StyleWidget.cardDark.withAlpha(200)
                : Colors.grey[200],
            shape: BoxShape.circle,
            child: resultImage != null
                ? Image.file(
                    File(resultImage!),
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  )
                : Image(
                    image: AssetImage(
                      ImagesUrl.profile,
                    ),
                    fit: BoxFit.fill)),
        Positioned(
          bottom: 0,
          right: 0,
          child: FuContainer.none(
            color: Colors.grey[200],
            width: 26,
            height: 26, shape: BoxShape.circle,
            border: Border.all(color: Colors.red, width: 3),
            // decoration:
            // const BoxDecoration(shape: BoxShape.circle, color: Colors.white10, border: Border.all(12)),
            child: const Center(
                child: Icon(Icons.edit_outlined,
                    color: StyleWidget.primaryClr, size: 18)),
          ),
        )
      ],
    ).onTap(() async {
      _openImagePicker().then((value) async {
        var image = await FuSharedPreferences.getString(
          'imageProfile',
        );
        setState(() {
          resultImage = image;
        });
      });
    });
  }
}
