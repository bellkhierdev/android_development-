//version 1.0.0+1

import 'package:flutter/material.dart';
import 'package:issue/export.dart';

//this is for divider between widget
Widget divider() {
  return Row(
    children: [
      Divider(
        height: 10.0,
        thickness: 0.5,
        color: FuAppTheme.isDarkMode == false
            ? Colors.black.withAlpha(50)
            : Colors.white.withAlpha(50),
      ).expand()
    ],
  );
}
