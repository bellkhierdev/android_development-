//version 1.0.0+1
import 'package:flutter/material.dart';
import 'package:flutter_utils_project/src/utils/extensions/widget_extensions.dart';
import 'package:issue/export.dart';

//this is custom  Input Field
class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;

  final Widget? widget;
  final TextInputType textInputType;
  const MyInputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            padding: const EdgeInsets.only(right: 14),
            margin: const EdgeInsets.only(top: 8.0),
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                TextFormField(
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  keyboardType: textInputType,
                  cursorColor:
                      FuAppTheme.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                  controller: controller,
                  style: sunTileStyle,
                  
                  decoration: InputDecoration(
                    
                    hintText: hint,
                    hintStyle: sunTileStyle,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: context.theme.backgroundColor,
                      width: 0,
                    )),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: context.theme.backgroundColor,
                      width: 0,
                    )),
                  ),
                ).expand(),
                widget == null ? Container() : Container(child: widget)
              ],
            ),
          )
        ],
      ),
    );
  }
}

//this is TextFromField

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? input;
  final TextInputType? number;
  final Function? onChanged;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidate;
  late bool? obscureText;

  MyTextFormField({
    Key? key,
    required this.controller,
    required this.input,
    required this.number,
    required this.onChanged,
    required this.validator,
    required this.autovalidate,
    this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    obscureText ??= false;
    return TextFormField(
        keyboardType: number,
        obscureText: obscureText!,
        controller: controller,
        cursorColor: kPrimaryColor,
        autovalidateMode: autovalidate,
        decoration: input,

        onChanged: (String value) {
          onChanged!();
        },
        expands: false,
        onSaved: (value) => value = value,
        validator: validator);
  }
}
