//version 1.0.0
import 'package:flutter/material.dart';
import 'package:issue/export.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;

  final Function() press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            login ? " ليس لدي حساب ? " : " بالفعل امتلك حساب ? ",
            style: TextStyle(
              color: FuAppTheme.isDarkMode == false
                  ? dart
                  : FuAppTheme.theme.primaryColor,
            ),
          ),
          GestureDetector(
            onTap: press,
            child: Text(
              login ? " إنشاء حساب جديد " : " تسجيل الدخول",
              style: TextStyle(
                color: FuAppTheme.isDarkMode == false
                    ? FuAppTheme.theme.primaryColor
                    : FuAppTheme.theme.textTheme.bodyText1!.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
