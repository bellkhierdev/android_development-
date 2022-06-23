//version 1.0.0+1
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:issue/export.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorResponse {
  //this OPP Dialog
  static awesomeDialog({
    required error,
    required BuildContext context,
    DialogType? dialogType,
    Color? color,
    String? btnCancel,
    String? description,
    String? btnOkText,
    Function()? btnOkOnPress,
    Function()? btnCancelOnPress,
    bool? dismissOnBackKeyPress,
  }) {
    return AwesomeDialog(
      context: context,
      dialogType: dialogType ?? DialogType.ERROR,
      animType: AnimType.SCALE, 
      dismissOnBackKeyPress: dismissOnBackKeyPress ?? true,
      headerAnimationLoop: false,
      title: error.toString(),
      btnOkText:btnOkText?? 'موافق',
      btnOkOnPress: btnOkOnPress ?? () {},
      btnCancelOnPress: btnCancelOnPress,
      // padding: EdgeInsets.only(
      //     right: color == Colors.red ? 20 : 0,
      //     left: color == Colors.red ? 20 : 0),
      btnCancelColor: btnOkOnPress != null ? Colors.grey : null,
      btnCancelText: btnCancel,
      desc: description,
      buttonsTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: MySize.size16,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w700),
      btnOkColor: color ?? Colors.green,
    ).show();
  }

//custom error dialog
  static customAwesomeDialog(error, context, DialogType dialogType) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.SCALE,
      headerAnimationLoop: false,
      title: error.toString(),
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
    ).show();
  }

  static showToastWidget(
      {bool? isShowToast,
      Color? colorShowToast,
      Color? textColor,
      required String error}) async {
    await Fluttertoast.showToast(
        msg: error,
        backgroundColor: colorShowToast ?? StyleWidget.primaryClr,
        webPosition: 'center',
        textColor: textColor ?? StyleWidget.white);
  }

//this parse string to int if evant error return  response error
  static convertStringToInt(TextEditingController controller, String? err,
      Color color, BuildContext context) {
    try {
      return int.parse(controller.text);
    } catch (e) {
      return FuErrorResponse.snackBarError(
          error: err!, context: context, color: color);
    }
  }

  //this is custom validate textField
  static String? customValidationTextField(
    val,
    error,
    lengthMin,
    lengthMax,
    intMain,
    intMax,
  ) {
    if (val != null && val.isEmpty) {
      return error.toString();
    } else if (val!.length < intMain) {
      return lengthMin.toString();
    } else if (val!.length > intMax) {
      return lengthMax.toString();
    }
    return null;
  }

//this is validation name
  static String? validationName(_nameController) {
    return FuInputValidation.validationTextField(
        controller: _nameController,
        error: "يجب إدخال الاسم",
        lengthMin: 'الاسم يجب ان لا يقل عن 10 حرف',
        lengthMax: 'الاسم يجب ان لا يزيد عن 80 حرف',
        main: 10,
        max: 80);
  }

//this is validation Issue
  static String? validationIssue(TextEditingController _issueController) {
    return FuInputValidation.validationTextField(
        controller: _issueController,
        error: "يجب إدخال التهمة",
        lengthMin: 'التهمة يجب ان لا تقل عن 3 احرف',
        lengthMax: 'التهمة يجب ان لا تزيد عن 80 حرف',
        main: 3,
        max: 80);
  }

//this is validation Issue Number
  static String? validationIssueNumber(
      TextEditingController _issueNumberController) {
    return FuInputValidation.validationTextField(
        controller: _issueNumberController,
        error: "يجب إدخال رقم القضية",
        lengthMin: 'رقم القضية يجب ان لا تقل عن (3) حروف او ارقام',
        lengthMax: 'رقم القضية يجب ان لا تزيد عن  (20) حروف او ارقام ',
        main: 3,
        max: 20);
  }

//this is validation Phone Number
  static String? autovaldationPhone(error, lengthMin, lengthMax, intMain,
      intMax, TextEditingController contoller, String reges) {
    RegExp regExp = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
    if (contoller.text.startsWith(' ') || contoller.text.endsWith(' ')) {
      return 'يجب ان لا بداءالنص بفراغ';
    } else if (contoller.text.isEmpty) {
      return error.toString();
    } else if (!regExp.hasMatch(contoller.text)) {
      return ' رقم الهاتف غير صالح';
    } else if (contoller.text.length < intMain) {
      return lengthMin.toString();
    } else if (contoller.text.length > intMax) {
      return lengthMax.toString();
    }
  }

  static submitDialog({
    required BuildContext context,
  }) async {
    return await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext cont) {
          context = cont;
          return WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              elevation: 0.0,
              backgroundColor: StyleWidget.white,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Lottie.asset('assets/lottie/loding.json',
                        height: 60, width: 60),
                    const Text('. . . انتضر لحظة من فضلك',
                        style: TextStyle(fontFamily: 'Cairo'))
                  ],
                ),
              ],
            ),
          );
        });
  }

//this is auto validate email
  static String? autoValidationEmail(val, error, lengthMin, lengthMax, intMain,
      intMax, TextEditingController contoller, err, String reges) {
    bool validate(String value) {
      RegExp regex = RegExp(reges);
      return (!regex.hasMatch(value)) ? false : true;
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern.toString());
    if (validate(contoller.text) == true) {
      return err.toString();
    } else if (contoller.text.startsWith(' ') || contoller.text.endsWith(' ')) {
      return 'يجب ان لا بداءالنص بفراغ';
    } else if (val != null && val.isEmpty) {
      return error.toString();
    } else if (val!.length < intMain) {
      return lengthMin.toString();
    } else if (val!.length > intMax) {
      return lengthMax.toString();
    } else if (!regExp.hasMatch(val.toString())) {
      return 'البريد الإلكتروني غير صالح';
    }
  }
}
