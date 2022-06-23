//version 1.0.0+1

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:issue/export.dart';

class StateAuth with ChangeNotifier {
  late AutovalidateMode _autoTextFieldEmile = AutovalidateMode.disabled;
  AutovalidateMode get autoTextFieldEmile => _autoTextFieldEmile;
// ignore: prefer_typing_uninitialized_variables
  var _accused;
  get accused => _accused;
  bool _obscureText = true;
  bool? get obscureText => _obscureText;
  bool ?_checkAccount ;
  bool? get checkAccount => _checkAccount;
  String? _myName;
  String? get myName => _myName;
  int _currantIndex = 0;
  int get currantIndex => _currantIndex;
  autoValidationEmile(TextEditingController value, String regexp) async {
    if (value.text.startsWith(RegExp(regexp)) | value.text.startsWith(' ')) {
      notifyListeners();
      return _autoTextFieldEmile = AutovalidateMode.disabled;
    }
  }

  void showAndHidePassword() async {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  getAccusedDate(value) {
    _accused = value;
    notifyListeners();
  }

  void skipIndex() {
    _currantIndex = onBoardingList.length - 1;
    notifyListeners();
  }

  void changeIndex() {
    _currantIndex++;
    notifyListeners();
  }

  void removeFromIndex() {
    _currantIndex--;
    notifyListeners();
  }

  void myNames(String name) {
    _myName = name;
    notifyListeners();
  }

  Future<void> isAccountTestIng() async {
    // check if user login by test account or no
    var checkAccount = await FuSharedPreferences.getBool(
      'TestAccount',
    );
    if (checkAccount != null && checkAccount == true) {
    
       _checkAccount = true;
         notifyListeners();
    } else {
     
       _checkAccount = false;
        notifyListeners();
    }
    log( 'checkAccount: $checkAccount');
  }
}
