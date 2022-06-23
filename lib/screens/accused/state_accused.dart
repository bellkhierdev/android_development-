//version 1.0.0+1

import 'package:issue/export.dart';
import 'package:flutter/material.dart';

class StateAccused with ChangeNotifier {
  int? _completed;
  int? get completed => _completed;

  List<Accused>? _userExist;
  List<Accused>? get userExist => _userExist;

  /* this is for get data Accused */




  /* this is for get data Accused */
  Future<int?> addAccuse(Accused accused) async {
    notifyListeners();
    return await DBHelper.insert(accused);
  }

  void delete(Accused accused) async {
    DBHelper.delete(accused);
    notifyListeners();
  }

  isCompleted(
    int id,
  ) {
    if (id == 0) {
      // notifyListeners();
      _completed = 0;
    } else {
      // notifyListeners();
      _completed = 1;
    }
  }

  /* this is for doing completed Accused */
 void accuseCompleted(int id, context, int typeAlarm) async {
    late String nameField;
    if (typeAlarm == 1) {
      nameField = 'isCompleted';
      typeAlarm = 1;
    } else if (typeAlarm == 2) {
      nameField = 'firstAlarm';
      typeAlarm = 1;
    } else if (typeAlarm == 3) {
      nameField = 'nextAlarm';
      typeAlarm = 1;
    } else if (typeAlarm == 4) {
      nameField = 'thirdAlert';
      typeAlarm = 1;
    }
  

    int data = await DBHelper.update(id, typeAlarm, nameField)
        .onError((error, stackTrace) {
    

      return ErrorResponse.awesomeDialog(
        error: stackTrace.toString(),
        context: context,
      );
    });
    notifyListeners();

    if (data == 1) {
      notifyListeners();
       _completed = 1;
    } else if (data == 2) {
      notifyListeners();
       _completed = 2;
    } else if (data == 3) {
      notifyListeners();
       _completed = 3;
    } else if (data == 4) {
      notifyListeners();
       _completed = 4;
    } else {
      notifyListeners();
       _completed = 0;
    }
  }

  Future<dynamic> updateAccuse(Accused accused) async {
    notifyListeners();

    return await DBHelper.updateAccused(accused);
  }

  /* this is for search Accused */
  Future<List<Accused>> searchDate(String name) async {
    return await DBHelper.db.searchData(name).then((value) => value!.toList());
  }

/* this is for search Accused */
  Future<List<Accused>> searchMyUser(String name) async {
    return await DBHelper.db.searchUser(name).then((value) => value!.toList());
  }

  isUserExist(BuildContext context, String query) async {
    Future<List<Accused>> data =
        searchMyUser(query).onError((error, stackTrace) {
    

      return ErrorResponse.awesomeDialog(
        error: stackTrace.toString(),
        context: context,
      );
    });

    await data.then((value) {
      if (value.isNotEmpty) {
        _userExist = value.toList();
      } else {
        _userExist = [];
        FuLog('no Data');
      }
    });
  }
}
