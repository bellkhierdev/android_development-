//version 1.0.0+1
import 'package:flutter/material.dart';

import '../../export.dart';

class HomeScreenProvider with ChangeNotifier {

  int _increment = 0;
  int get increment => _increment;

  //This is for increment the count of notification
  Future<void> incrementCountNotification(int count) async {
    var valueCount = await FuSharedPreferences.getString(
      'countNotification',
    );

    if (valueCount == null) {
      await FuSharedPreferences.setString(
          'countNotification', count.toString());
      _increment = count;
    } else {
      await FuSharedPreferences.setString(
          'countNotification', (int.parse(valueCount) + count).toString());
      _increment = (int.parse(valueCount.toString()) + count);
    }
    notifyListeners();
  }

  void deleteCountNotification() async {
    await FuSharedPreferences.deleteString(
      'countNotification',
    );
    _increment = 0;
    notifyListeners();
  }
 
}
