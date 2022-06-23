// class CheckInternet
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'validate/error_response.dart';

class CheckInternet {

  //new
  static Future<List<InternetAddress>> check(
      {required String url, required int timeout}) async {
    try {
      final result = await InternetAddress.lookup(url)
          .timeout(Duration(seconds: timeout), onTimeout: () {
        return ErrorResponse.showToastWidget(
            error: 'انتهت مدةالاتصال بالخادم تاكد من اتصالك بالانترنت',
            colorShowToast: Colors.redAccent);
      });
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return result;
      }
      return [];
    } catch (_) {
      return [];
    }
   
  }
}
