//version 1.0.0+1

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:issue/export.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../export.dart';

class UtilsSettings {
  //------------THIS IS FOR LOG OUT ACCOUNT FROM GOOGLE AND FIREBASE --------------//
  static Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await FuSharedPreferences.deleteString('UserId');
    await FuSharedPreferences.deleteString('Username');

    Navigator.of(context)
        .pushReplacement(CostumeTransition(const SignInScreen()));
  }

  static List<String> images = [
    "assets/developer/najeeb.jpg",
    "assets/developer/ahmed.jpg",
    "assets/developer/khalid.jpg",
  ];

  static List<String> doing = [
    "برمجة وتصميم",
    "مطور الفكرة",
    "مؤسس الفكرة",
  ];

  static List<String> names = [
    "نجيب عسلان",
    "احمد عسلان",
    "خالد عمر",
  ];

  static Widget singleOption(
      {IconData? iconData,
      required String option,
      Widget? navigation,
      bool enableOnTap = false,
      required BuildContext context}) {
    return Container(
      padding: FuSpacing.y(8),
      child: InkWell(
        onTap: () async {
          if (enableOnTap) {
            var whatsappUrl = "whatsapp://send?phone=+967773228315";
            await canLaunch(
              whatsappUrl,
            )
                ? launch(whatsappUrl)
                : '';
          } else if (navigation != null) {
            Navigator.push(context, CostumeTransition(navigation));
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              size: 22,
              color: FuAppTheme.theme.colorScheme.onBackground,
            ),
            FuSpacing.width(16),
            FuText.b1(option, fontWeight: 600).expand(),
            Icon(MdiIcons.chevronLeft,
                size: 22, color: FuAppTheme.theme.colorScheme.onBackground),
          ],
        ),
      ),
    );
  }
//------------THIS IS FOR LOADING WHEN DO DOWNLOAD DATA FROM GOOGLE DRIVE --------------//

  static loadingGoogleDrive() {
    return WillPopScope(
        onWillPop: () async => false,
        child: SimpleDialog(
            elevation: 0.0,
            backgroundColor: FuAppTheme.isDarkMode == false
                ? Colors.white
                : FuAppTheme.theme.scaffoldBackgroundColor,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Lottie.asset(
                    ImagesUrl.uploading,
                    height: 100,
                    width: 100,
                  ),
                  Text('. . . انتضر لحظة من فضلك',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: FuAppTheme.theme.textTheme.bodyText1!.color))
                ],
              )
            ]));
  }

//------------THIS IS FOR LOADING WHEN DO UPLOADED DATA TO GOOGLE DRIVE --------------//

  static uploadGoogleDrive() {
    return WillPopScope(
        onWillPop: () async => false,
        child: SimpleDialog(
            elevation: 0.0,
            backgroundColor: FuAppTheme.isDarkMode == false
                ? Colors.white
                : FuAppTheme.theme.scaffoldBackgroundColor,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Lottie.asset('assets/lottie/upload_to_drive.json',
                      height: 100, width: 100),
                  Text('. . . انتضر لحظة من فضلك',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: FuAppTheme.theme.textTheme.bodyText1!.color))
                ],
              )
            ]));
  }
}

class CustomListBody extends StatelessWidget {
  const CustomListBody({
    Key? key,
    required this.index,
    required this.widgets,
  }) : super(key: key);

  final int index;
  final Widget widgets;

  @override
  Widget build(BuildContext context) {
    return widgets;
  }
}
