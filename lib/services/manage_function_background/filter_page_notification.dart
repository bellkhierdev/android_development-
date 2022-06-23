import 'dart:developer';

import 'package:issue/data/models/notification.dart';

import '../../data/models/Accuse.dart';

class FilterPageNotification {
  static DateTime now = DateTime.now();

  DateTime onlyDate2 = DateTime(
    now.year,
    now.month,
    now.day,
  );

  //-----for first alarm -----//
  List<Accused> filterFirstNotification(
      {required List<Accused> value, required bool loadForNotificationPage}) {
    List<Accused> first = value.where((item) {
      var pars = DateTime.parse(item.date.toString());
      DateTime onlyDate = DateTime(
        pars.year,
        pars.month,
        pars.day,
      );

      String firstAlarm = onlyDate2
          .difference(onlyDate.add(const Duration(hours: 144)))
          .inDays
          .toString();
      //this is alarm today
      if (loadForNotificationPage
          ? firstAlarm == '0'
          : item.firstAlarm == 0 && firstAlarm == '0') {
        return loadForNotificationPage
            ? firstAlarm == '0'
            : item.firstAlarm == 0 && firstAlarm == '0';
      } //this is alarm tomorrow
      else if (loadForNotificationPage
          ? firstAlarm == '-1'
          : item.firstAlarm == 0 && firstAlarm == '-1') {
        return loadForNotificationPage
            ? firstAlarm == '-1'
            : item.firstAlarm == 0 && firstAlarm == '-1';
      } else {
        // AppTerminated.whineAppIsTerminated(
        //     id: DateTime.now().microsecond,
        //     accuseName: 'else first',
        //     title: 'for first alarm');
        return false;
      }
    }).toList();
    return first;
  }

  // -----for next alarm -----//
  List<Accused> filterNextNotification(
      {required List<Accused> value, required bool loadForNotificationPage}) {
    List<Accused> next = value.where((item) {
      var pars = DateTime.parse(item.date.toString());
      DateTime onlyDate = DateTime(
        pars.year,
        pars.month,
        pars.day,
      );

      String nextAlarm = onlyDate2
          .difference(onlyDate.add(const Duration(hours: 1224)))
          .inDays
          .toString();

      if (loadForNotificationPage
          ? nextAlarm == '0'
          : item.nextAlarm == 0 && item.firstAlarm == 1 && nextAlarm == '0') {
        return loadForNotificationPage
            ? nextAlarm == '0'
            : item.nextAlarm == 0 && item.firstAlarm == 1 && nextAlarm == '0';
      } else if (loadForNotificationPage
          ? nextAlarm == '-1'
          : item.nextAlarm == 0 && item.firstAlarm == 1 && nextAlarm == '-1') {
        return loadForNotificationPage
            ? nextAlarm == '-1'
            : item.nextAlarm == 0 && item.firstAlarm == 1 && nextAlarm == '-1';
      } else {
        return false;
      }
    }).toList();
    return next;
  }

  // ---- for third alarm -----//
  List<Accused> filterThirdNotification(
      {required List<Accused> value, required bool loadForNotificationPage}) {
    List<Accused> third = value.where((item) {
      var pars = DateTime.parse(item.date.toString());

      DateTime onlyDate = DateTime(
        pars.year,
        pars.month,
        pars.day,
      );

      String thirdAlarm = onlyDate2
          .difference(onlyDate.add(const Duration(hours: 2304)))
          .inDays
          .toString();
      if (loadForNotificationPage
          ? thirdAlarm == '0'
          : item.thirdAlert == 0 && item.nextAlarm == 1 && thirdAlarm == '0') {
        return loadForNotificationPage ? thirdAlarm == '0' : thirdAlarm == '0';
      } else if (loadForNotificationPage
          ? thirdAlarm == '-1'
          : item.thirdAlert == 0 && item.nextAlarm == 1 && thirdAlarm == '-1') {
        return loadForNotificationPage
            ? thirdAlarm == '-1'
            : thirdAlarm == '-1';
      } else {
        return false;
      }

      // return item.thirdAlert == 0 && item.nextAlarm == 1;
    }).toList();
    return third;
  }

  // ---- Obtaining data that had an expiration notice four days ago -----//
  List<NotificationModel> filterDataForScreenNotification(
      {required List<NotificationModel> value}) {
    List<NotificationModel> forNotification = value.where((item) {
      var pars = DateTime.parse(item.sentTime.toString());
      String differenceDate = DateTime.now()
          .difference(pars.add(const Duration(days: 0)))
          .inDays
          .toString();
      if (differenceDate == '0') {
        return differenceDate == '0';
      } else if (differenceDate == '-1') {
        return differenceDate == '-1';
      } else {
        return false;
      }
    }).toList();
    return forNotification;
  }
}
