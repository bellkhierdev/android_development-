//version 1.0.0+1

import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:issue/export.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:remove_emoji/remove_emoji.dart';

class AddAccusedScreen extends StatefulWidget {
  final Accused? accused;
  const AddAccusedScreen({Key? key, required this.accused}) : super(key: key);

  @override
  _AddAccusedScreen createState() => _AddAccusedScreen();
}

class _AddAccusedScreen extends State<AddAccusedScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _issueNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  bool lan = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await Jiffy.locale(
          "en"); //this is for translation date to language english
    });
    if (widget.accused != null) {
      _nameController.text = widget.accused!.name.toString();
      _issueController.text = widget.accused!.accused.toString();
      _issueNumberController.text = widget.accused!.issueNumber.toString();
      _phoneController.text = '';
      if (widget.accused!.phoneNu == 0) {
        _phoneController.text = '';
      } else {
        _phoneController.text = widget.accused!.phoneNu.toString();
      }
      _noteController.text = widget.accused!.note ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issueController.dispose();
    _issueNumberController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  FuCustomTheme? customAppTheme;
  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context); //this is for initialize ThemeData
    MySize().init(context);

    return Directionality(
      textDirection: lan ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: FuAppTheme.isDarkMode == false
            ? Colors.white
            : themeData.scaffoldBackgroundColor,
        appBar: widget.accused != null
            ? AppBar(
                elevation: 0,
                backgroundColor: FuAppTheme.isDarkMode == false
                    ? Colors.white
                    : themeData.scaffoldBackgroundColor,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: FuAppTheme.isDarkMode == false
                        ? Colors.black
                        : FuAppTheme.customTheme.withe,
                  ),
                ),
              )
            : null,
        body: Container(
          padding: EdgeInsets.only(
              left: MySize.size20!, right: MySize.size20!, top: MySize.size20!),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  widget.accused == null
                      ? 'اظافة بيانات المتهم'
                      : 'تعديل بيانات المتهم',
                  style: headingStyle,
                ),
                MyInputField(
                  title: 'الاسم',
                  hint: 'أدخل الاسم الكامل',
                  controller: _nameController,
                  textInputType: TextInputType.text,
                ),
                MyInputField(
                  title: 'التهمة',
                  hint: 'أدخل التهمة',
                  controller: _issueController,
                  textInputType: TextInputType.text,
                ),
                MyInputField(
                  title: 'الهاتف',
                  hint: 'أدخل رقم هاتف وكيل المتهم ',
                  controller: _phoneController,
                  textInputType: TextInputType.phone,
                ),
                MyInputField(
                  title: 'رقم القضية',
                  hint: 'أدخل رقم القضية',
                  controller: _issueNumberController,
                  textInputType: TextInputType.text,
                ),
                MyInputField(
                  title: 'الملاحظة',
                  hint: 'أدخل الملاحظة',
                  controller: _noteController,
                  textInputType: TextInputType.text,
                ),
                18.height,
                Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyButton(
                        label: widget.accused == null ? 'إضافة' : 'تعديل',
                        onTap: () async => await validateInput())
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //this is for validation data after save data
  validateInput() async {
    log('checkAccount: ${context.read<StateAuth>().checkAccount.toString()}');

    if (context.read<StateAuth>().checkAccount!) {
      Navigator.push(
        context,
        CostumeTransition(const SignUpScreen()),
      );
    } else {
      if (ErrorResponse.validationName(_nameController) != null) {
        return FuErrorResponse.snackBarError(
          error: ErrorResponse.validationName(_nameController)!,
          context: context,
          color: StyleWidget.pinkClr,
        );
      } else if (ErrorResponse.validationIssue(_issueController) != null) {
        return FuErrorResponse.snackBarError(
          error: ErrorResponse.validationIssue(_issueController)!,
          context: context,
          color: StyleWidget.pinkClr,
        );
      } else if (ErrorResponse.validationIssueNumber(_issueNumberController) !=
          null) {
        return FuErrorResponse.snackBarError(
          error: ErrorResponse.validationIssueNumber(_issueNumberController)!,
          context: context,
          color: StyleWidget.pinkClr,
        );
      } else if (_phoneController.text.removemoji.trim().isNotEmpty) {
        if (ErrorResponse.autovaldationPhone(
                "يجب ادخال رقم الهاتف",
                'رقم الهاتف يجب ان يقل عن 9 ارقام',
                'رقم الهاتف يجب ان يزيد عن 9 ارقام',
                9,
                9,
                _phoneController,
                "^[0-9]") !=
            null) {
          return FuErrorResponse.snackBarError(
            error: ErrorResponse.autovaldationPhone(
                "يجب ادخال رقم الهاتف",
                'رقم الهاتف يجب ان يقل عن 9 ارقام',
                'رقم الهاتف يجب ان يزيد عن 9 ارقام',
                9,
                9,
                _phoneController,
                "^[0-9]")!,
            context: context,
            color: StyleWidget.pinkClr,
          );
        } else {
          if (_nameController.text.removemoji.isNotEmpty &&
              _issueNumberController.text.removemoji.isNotEmpty &&
              _issueController.text.removemoji.isNotEmpty) {
            return await saveAccusedAndNotification();
          }
        }
      } else {
        if (_nameController.text.isNotEmpty &&
            _issueNumberController.text.isNotEmpty &&
            _issueController.text.isNotEmpty) {
          return await saveAccusedAndNotification();
        }
      }
    }
  }

  //------------------------This is add issue or edit issue and do notifications----------------------//
  saveAccusedAndNotification() async {
    try {
/* -------------------------------------- THIS IS FOR ADD DATA And NOTIFICATION ------------------------------------------ */
      await context
          .read<StateAccused>()
          .isUserExist(context, _nameController.text.toString().trim());
      if (widget.accused == null) {
        if (context.read<StateAccused>().userExist!.isNotEmpty &&
            context.read<StateAccused>().userExist?.first.name != null) {
          return ErrorResponse.awesomeDialog(
            error: 'يوجد متهم بهذا الاسم',
            context: context,
            dialogType: DialogType.ERROR,
          );
        }
        int? saveData = await context
            .read<StateAccused>()
            .addAccuse(Accused(
                note: _noteController.text.removemoji.isNotEmpty
                    ? _noteController.text.removemoji
                    : '',
                accused: _issueController.text.removemoji.toString(),
                issueNumber: _issueNumberController.text.removemoji.toString(),
                name: _nameController.text.removemoji.toString(),
                date: DateTime.now().toString().removemoji,
                sentTime: '',
                firstAlarm: 0,
                nextAlarm: 0,
                thirdAlert: 0,
                isCompleted: 0,
                phoneNu: _phoneController.text.removemoji.trim().isNotEmpty
                    ? int.parse(
                        _phoneController.text.removemoji.trim().toString())
                    : 0))
            .onError((error, stackTrace) => ErrorResponse.awesomeDialog(
                  error: error.toString(),
                  context: context,
                  dialogType: DialogType.ERROR,
                ));

        // ignore: unnecessary_type_check
        if (saveData is int) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const NavigationBarScreen()),
              (Route<dynamic> route) => route is NavigationBarScreen);
          // });
        }
      } else if (widget.accused != null) {
/* --------------------------------------THIS IS FOR ADD EDIT ACCUSED ------------------------------------------ */

        if (context.read<StateAccused>().userExist!.isNotEmpty &&
            context.read<StateAccused>().userExist?.first.id !=
                widget.accused?.id) {
          return ErrorResponse.awesomeDialog(
            error: 'يوجد متهم بهذا الاسم',
            context: context,
            dialogType: DialogType.ERROR,
          );
        }
        int updateDate = await context
            .read<StateAccused>()
            .updateAccuse(Accused(
                note: _noteController.text.removemoji.isNotEmpty
                    ? _noteController.text.removemoji
                    : '',
                accused: _issueController.text.removemoji.toString(),
                issueNumber: _issueNumberController.text.removemoji.toString(),
                name: _nameController.text.removemoji.toString(),
                date: widget.accused!.date.toString().removemoji,
                id: widget.accused!.id,
                phoneNu: _phoneController.text.removemoji.trim().isNotEmpty
                    ? int.parse(
                        _phoneController.text.removemoji.trim().toString())
                    : 0))
            .onError((error, stackTrace) {
          FuLog(error.toString());
          FuLog(stackTrace.toString());

          return ErrorResponse.awesomeDialog(
            error: stackTrace.toString(),
            context: context,
            dialogType: DialogType.ERROR,
          );
        });

        if (updateDate is int) {
          return await UtilsLocalNotification()
              .cancelNotificationById(widget.accused!.id!)
              .then((value) async {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const NavigationBarScreen()),
                (Route<dynamic> route) => route is NavigationBarScreen);
          });
        }
      }
    } catch (e) {
      FuLog('this is The Error====>$e');
      ErrorResponse.awesomeDialog(
        error: e.toString(),
        context: context,
        dialogType: DialogType.ERROR,
      );
    }
  }
}
