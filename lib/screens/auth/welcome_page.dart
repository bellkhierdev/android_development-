//version 1.0.0+1

import 'package:flutter/material.dart';
import 'package:issue/export.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/add_data_test.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late ThemeData themeData;
    themeData = Theme.of(context);

    return Scaffold(
        backgroundColor: FuAppTheme.isDarkMode == false
            ? Colors.white
            : themeData.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  ImagesUrl.welcomeSketch,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 2,
                ),
                Text('! أهلا',
                    style: TextStyle(
                        color: themeData.textTheme.bodyText1!.color,
                        fontSize: 28,
                        wordSpacing: 2,
                        fontWeight: FontWeight.bold)),
                Text(
                  '!مرحباً بك في مواعيد تمديدات الحبس الإحتياطي',
                  textAlign: TextAlign.center,
                  style: FuAppTheme.theme.textTheme.bodyText1!.copyWith(
                      letterSpacing: 3,
                      fontSize: 23,
                      wordSpacing: 2,
                      color:FuAppTheme.isDarkMode?Colors.grey: const Color(0xFF323649)),
                ),
                SizedBox(
                  height: 4.h,
                ),
                MyButton1(
                  color: StyleWidget.primaryClr,
                  width: context.width,
                  title: 'تسجيل الدخول',
                  func: () async {
                    await FuSharedPreferences.setBool('seen', true);
                    Navigator.pushAndRemoveUntil(
                      context,
                      CostumeTransition(const SignInScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                MyButton1(
                  color: StyleWidget.primaryClr,
                  width: 80.w,
                  title: 'انشاء حساب',
                  func: () async {
                    
                    await FuSharedPreferences.setBool('seen', true);

                    Navigator.pushAndRemoveUntil(
                      context,
                      CostumeTransition(const SignUpScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  width: 80.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      border:
                          Border.all(color: StyleWidget.primaryClr, width: 2)),
                  child: MaterialButton(
                    onPressed: () async {
                      await FuSharedPreferences.setBool('TestAccount', true);
                      await context.read<StateAuth>().isAccountTestIng();
                      await ServicesDatabase().clearAllDatabaseTables().then((value)
                      //----- this is for add data testing ----//
                      async =>  await DBHelper.addDataTest(AddDataTest.data)
                      );
                    
                      Navigator.pushAndRemoveUntil(
                        context,
                        CostumeTransition(const NavigationBarScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Center(
                      child: Text('سجل لاحقاً',
                          style: TextStyle(
                              color: FuAppTheme.isDarkMode
                                  ? FuAppTheme.theme.textTheme.bodyText1!.color
                                  : StyleWidget.primaryClr,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
            .paddingSymmetric(
              horizontal: 40,
            )
            .paddingTop(80));
  }
}

class MyButton1 extends StatelessWidget {
  const MyButton1(
      {Key? key,
      required this.color,
      required this.width,
      required this.title,
      required this.func})
      : super(key: key);

  final Color color;
  final double width;
  final String title;
  final Function() func;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 0.1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: color,
      ),
      child: MaterialButton(
        onPressed: func,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(fontSize: 13.sp, color: StyleWidget.white),
        ),
      ),
    );
  }
}
