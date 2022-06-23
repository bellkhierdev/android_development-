//version 1.0.0+1
import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:issue/export.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'onboarding.dart';
enum ComingFrom { googlDrive, addAccuse,wellCome }

class UtilsAuth {
  //this is sign google in with firebase

  static Future<dynamic> signInWithGoogle(context) async {
    late BuildContext dialogContext;

    try {
      //this is UtilsAuth waiting signp
      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext cont) {
            dialogContext = cont;

            return willPopScope();
          });

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
         await ServicesDatabase().clearAllDatabaseTables();
        
        if (value != null) {
          await FuSharedPreferences.setString('UserId', googleUser.id);
          await FuSharedPreferences.setString( 'Username', googleUser.displayName);
         await FuSharedPreferences.setBool('TestAccount', false);

          

          Navigator.pop(dialogContext); //this is for close showDialog
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const NavigationBarScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          ErrorResponse.customAwesomeDialog(
              'something wronging', context, DialogType.WARNING);
        }
      });
    } catch (e) {
      FuLog(e.toString());
      Navigator.pop(dialogContext);

      return UtilsAuth.parseError(
        e,
        context,
      );
    }
    return null;
  }

  static const Color color1 = Color(0xFF3D5AD1);
  static const Color color2 = Color(0xFF2048E6);
  static const Color color3 = Color(0xFF6291E2);
  static const Color color4 = Color(0xFF548AE7);

//this is dialog
  static WillPopScope willPopScope() {
    return WillPopScope(
      onWillPop: () async => false,
      child: SimpleDialog(
        elevation: 0.0,
        backgroundColor: FuAppTheme.theme.scaffoldBackgroundColor,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Lottie.asset(ImagesUrl.loading, height: 60, width: 60),
              Text('. . . انتضر لحظة من فضلك',
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      color: FuAppTheme.theme.textTheme.bodyText1!.color))
            ],
          ),
        ],
      ),
    );
  }

  //this is for check if is loading or loaded
  static Loading defaultLoading = Loading.loading;
  static void checkLoading(BuildContext context, {Loading? loading}) {
    loading ??= defaultLoading;
    switch (loading) {
      case Loading.loaded:
        return Navigator.pop(context);
      default:
        return;
    }
  }

//handle Error Firebase

  static parseError(ex, BuildContext context,
      {bool? isShowToast, Color? colorShowToast, Color? textColor}) async {
    if (ex is SocketException) {
      if (isShowToast != null && isShowToast) {
        await ErrorResponse.showToastWidget(
            colorShowToast: colorShowToast,
            isShowToast: isShowToast,
            textColor: textColor,
            error: 'الخادم غير متصل تأكد من اتصالك بالإنترنت ');
      } else {
        ErrorResponse.customAwesomeDialog(
          'الخادم غير متصل تأكد من اتصالك بالإنترنت',
          context,
          DialogType.WARNING,
        );
      }

      //print('No Internet connection 😑');
    } else if (ex is HttpException) {
      if (isShowToast != null && isShowToast) {
        await ErrorResponse.showToastWidget(
            colorShowToast: colorShowToast,
            isShowToast: isShowToast,
            textColor: textColor,
            error: 'تعذر العثور على البيانات ');
      } else {
        ErrorResponse.customAwesomeDialog(
          "تعذر العثور على البيانات ",
          context,
          DialogType.WARNING,
        );
      }
      //print("تعذر العثور على البيانات ");
    } else if (ex is FormatException) {
      if (isShowToast != null && isShowToast) {
        await ErrorResponse.showToastWidget(
            colorShowToast: colorShowToast,
            isShowToast: isShowToast,
            textColor: textColor,
            error: 'تنسيق استجابة سيئ ');
      } else {
        ErrorResponse.customAwesomeDialog(
          "تنسيق استجابة سيئ 👎",
          context,
          DialogType.WARNING,
        );
        // print("تنسيق استجابة سيئ 👎");
      }
    } else if (ex is PlatformException) {
      if (isShowToast != null && isShowToast) {
        await ErrorResponse.showToastWidget(
            colorShowToast: colorShowToast,
            isShowToast: isShowToast,
            textColor: textColor,
            error: 'تاكد من اتصالك بالانترنت');
      } else {
        ErrorResponse.customAwesomeDialog(
          "تاكد من اتصالك بالانترنت",
          context,
          DialogType.WARNING,
        );
        //  print("👎تاكد من اتصالك بالانترنت");
      }
    } else if (ex is FirebaseAuthException) {
      String? errorMessage;
      switch (ex.code) {
        case "invalid-email":
          errorMessage = "يبدو أن عنوان بريدك الإلكتروني مشوه";

          break;
        case "invalid-password":
          errorMessage = "كلمة المرور غير صالحة";
          break;
        case "wrong-password":
          errorMessage = "خاطئة في كلمة المرور";
          break;
        case "email-already-in-use":
          errorMessage =
              "عنوان البريد الإلكتروني قيد الاستخدام بالفعل من قبل حساب آخر";
          break;
        case "user-not-found":
          errorMessage = "لم يتم العثور على المستخدم";
          break;
        case "user-disabled":
          errorMessage = "تم تعطيل المستخدم مع هذا البريد الإلكتروني";
          break;
        case "too-many-requests":
          errorMessage = "طلبات كثيرة جدا";
          break;
        case "network-request-failed":
          errorMessage = "👎تاكد من اتصالك بالانترنت";
          break;
        case "operation-not-allowed":
          errorMessage =
              "لم يتم تمكين تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور";
          break;
        default:
          errorMessage = "${ex.code} حدث خطأ غير محدد";
      }
      ErrorResponse.customAwesomeDialog(
        errorMessage,
        context,
        DialogType.WARNING,
      );
    } else if (ex is TimeoutException) {
      if (isShowToast != null && isShowToast) {
        await ErrorResponse.showToastWidget(
            colorShowToast: colorShowToast,
            isShowToast: isShowToast,
            textColor: textColor,
            error: 'انتهت مدةالاتصال بالخادم');
      } else {
        //    print("انتهت مدةالاتصال بالخادم👎");
        ErrorResponse.customAwesomeDialog(
          "انتهت مدةالاتصال بالخادم",
          context,
          DialogType.WARNING,
        );
      }
    } else {
      if (isShowToast != null && isShowToast) {
        await ErrorResponse.showToastWidget(
            colorShowToast: colorShowToast,
            isShowToast: isShowToast,
            textColor: textColor,
            error: 'تاكد من اتصالك بالانترنت');
      } else {
        ErrorResponse.customAwesomeDialog(
          ex.toString(),
          context,
          DialogType.WARNING,
        );
      }
    }
    return;
  }
}

List<OnBoardingModel> onBoardingList = const [
  OnBoardingModel(
    img: ImagesUrl.onboradingone,
    title: 'إدارة مهمتك',
    description:
        'باستخدام هذا التطبيق ، يمكنك تنظيم جميع مهامك وواجباتك من جانب المتهمين',
  ),
  OnBoardingModel(
    img: ImagesUrl.onboradingtwo,
    title: 'وفر وقتك',
    description: ' أضف متهم وسيذكرك التطبيق بذلك عند الوقت المحدد له',
  ),
  OnBoardingModel(
    img: ImagesUrl.onboradingthree,
    title: 'حقق أهدافك',
    description: ' تتبع أنشطتك و دير مهامك بشكل اضمن وبدون اي اشكالية',
  ),
];
