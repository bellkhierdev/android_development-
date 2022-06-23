//version 1.0.0

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../export.dart';

class FilterProvider with ChangeNotifier {
  FilterByTime? _defaultFilterByTime;
  FilterByTime? get defaultFilterByTime => _defaultFilterByTime;

  int? _radioValue;
  int? get radioValue => _radioValue;

  String? _idNumberIssueValue;
  String? get idNumberIssueValue => _idNumberIssueValue;


String ? _numberIssue;
  String? get numberIssue => _numberIssue;
  int? _selectedDate;
  int? get selectedDate => _selectedDate;

  bool? _isLoading;
  bool? get isLoading => _isLoading;

  manageRadioValue(int? value) {
    _radioValue = 0;
    switch (value) {
      case 0:
        //if value equal 0 return name Ascending order
        _radioValue = 0;
        break;
      case null:
        //if value equal null return default result
        _radioValue = 0;
        break;
      case 1:
        //if value equal 1 return date Descending Order
        _radioValue = 1;
        break;
      case 2:
        //if value equal 2 return near finish accused issue
        _radioValue = 2;
        break;
      case 3:
        //if value equal 2 return  is Completed accused issue
        _radioValue = 3;
        break;

      default:
        //this is for if not equal everything's do this
        //this doing return default data stor
        return _radioValue = 4;
    }

    notifyListeners();
  }
 //---- This is filter by number issue ------- //
  manageNumberIssue({String ?id,String? numberIssue}) {
    _idNumberIssueValue = id;
    _numberIssue = numberIssue;
    notifyListeners();
  }
 
  Future<List<Accused>?> getAccuse(
    context,
  ) async {
    notifyListeners();
    return await DBHelper.db.query();
  }

  /* this is for enable Notification for Accused   by id*/
  Future<int?> enableAccuseNotification({
    required int id,
    required String date,
  }) async {
    notifyListeners();
    return await DBHelper.enableAccused(id: id, date: date);
  }

  Future<List<Accused>?> getAccuseById({required int id}) async {
    // notifyListeners();
    return await DBHelper.db.getAccuseById(id: id);
  }

  // ----- This is for get data by  Expired Time ---------//
  Future<List<Accused>?> getDataByExpiredTime(
    context,
  ) async {
    notifyListeners();
    return await DBHelper.db.customQueryByExpiredTime();
  }

  getDefaultFilterByTime(FilterByTime filterByTime) {
    notifyListeners();
    return _defaultFilterByTime = filterByTime;
  }
 

  int? changeSelectedDate(int? index) {
    _selectedDate = index;
    notifyListeners();
  }
}
