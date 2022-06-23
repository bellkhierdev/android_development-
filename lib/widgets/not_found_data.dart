//version 1.0.0+1
import 'package:flutter/material.dart';
import 'package:issue/export.dart';

class NotFoundData extends StatelessWidget {
  final String? error;
  const NotFoundData({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset(
        ImagesUrl.notFound,
      ),
      Text(
        error.toString(),
        style: TextStyle(
            color: FuAppTheme.theme.primaryColor,
            fontSize: 30,
            fontFamily: 'Cairo'),
      ),
    ]);
  }
}
