//version 1.0.0+1

import 'package:flutter/material.dart';
import 'package:issue/export.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: FuAppTheme.theme.primaryColor),
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: StyleWidget.fontName,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
