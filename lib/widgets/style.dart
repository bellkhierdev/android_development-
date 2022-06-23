//version 1.0.0+1
import 'package:flutter/material.dart';
import 'package:issue/export.dart';

TextStyle get subHeadingStyle {
  return TextStyle(
    fontSize: 24,
    fontFamily: StyleWidget.fontName,
    fontWeight: FontWeight.bold,
    color: FuAppTheme.isDarkMode ? Colors.grey[400] : Colors.grey,
  );
}

TextStyle get headingStyle {
  return TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    fontFamily: StyleWidget.fontName,
    color: FuAppTheme.isDarkMode ? Colors.white : Colors.black,
  );
}

TextStyle get titleStyle {
  return TextStyle(
    fontSize: 16,
    fontFamily: StyleWidget.fontName,
    fontWeight: FontWeight.w700,
    color: FuAppTheme.isDarkMode ? Colors.white : Colors.black,
  );
}

TextStyle get sunTileStyle {
  return TextStyle(
    fontSize: 16,
    fontFamily: StyleWidget.fontName,
    fontWeight: FontWeight.bold,
    color: FuAppTheme.isDarkMode ? Colors.grey[100] : Colors.grey[600],
  );
}

const kPrimaryColor = Color(0xff3d63ff);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const dart = Color(0xFF8C969E);

class StyleWidget {
  StyleWidget._();
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color backgroundButton = Color(0xFFE6E7EE);
  static const Color circleColor = Color(0xFF2979ff);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);
  static const Color black = Color(0xFF020203);
  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color blue = Colors.blueAccent;
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color deepOrange = Colors.deepOrange;
  static const Color red = Colors.red;
  static const Color myGrey = Colors.grey;
  static const Color purple = Colors.purple;
  static Color costmary = const Color(0xFF313A44).withOpacity(0.9);
  static const Color white70 = Colors.white70;
  static const Color pinkClr = Color(0xFFff4667);
  static const Color primaryClr = Color(0xFF4e5ae8);
  static const Color yellowClr = Color(0xFFFFB746);
  static Color cardDark = const Color(0xFF2D303F).withAlpha(100);

  // static const String fontName = 'Roboto';
  static const String fontName = '';
  //'Cairo';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static FontWeight fontWeight = FontWeight.values[4];
  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText,
  );
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
