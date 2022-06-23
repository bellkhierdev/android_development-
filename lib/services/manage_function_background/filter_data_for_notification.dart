import 'dart:developer';
import 'package:issue/services/manage_function_background/terminated_app.dart';
import 'package:jiffy/jiffy.dart';
import '../../data/models/notification.dart';
import '../../export.dart';
import 'background_fetch.dart';
import 'filter_page_notification.dart';
import 'package:provider/provider.dart';

class FilterDataForNotification {
//-------- This is for filter data for notification expiration----------//
  Future<List<NotificationModel>?> filterData({
    required bool isWhenAppIsTerminated,
    required bool loadForNotificationPage,
  }) async {
    try {
      await Jiffy.locale("ar");
      return await DBHelper.db
          .customQueryByNotExpiredTime(
              forPageNotification: loadForNotificationPage)
          .then((value) async {
        if (value != null) {
        
          //-----for first alarm -----//

          List<Accused> first =
              FilterPageNotification().filterFirstNotification(
            value: value,
            loadForNotificationPage: loadForNotificationPage,
          );

          // -----for next alarm -----//

          List<Accused> next = FilterPageNotification().filterNextNotification(
            value: value,
            loadForNotificationPage: loadForNotificationPage,
          );

          // ---- for third alarm -----//
          List<Accused> third =
              FilterPageNotification().filterThirdNotification(
            value: value,
            loadForNotificationPage: loadForNotificationPage,
          );

          if (loadForNotificationPage == true) {
            List<Map<String, Object>>? firstMap = [];
            List<Map<String, Object>>? nextMap = [];
            List<Map<String, Object>>? thirdMap = [];
            if (first.isNotEmpty) {
              for (var e in first) {
                firstMap.addAll([
                  {
                    "id": e.id!,
                    'name': e.name.toString(),
                    'typeAlarm': 'الاول',
                    'dateTime': e.date.toString(),
                    'sentTime': e.sentTime.toString()
                  }
                ]);
              }
            }
            if (next.isNotEmpty) {
              for (var e in next) {
                nextMap.addAll([
                  {
                    "id": e.id!,
                    'name': e.name.toString(),
                    'typeAlarm': 'الثاني',
                    'dateTime': e.date.toString(),
                    'sentTime': e.sentTime.toString()
                  }
                ]);
              }
            }

            if (third.isNotEmpty) {
              for (var e in third) {
                thirdMap.addAll([
                  {
                    "id": e.id!,
                    'name': e.name.toString(),
                    'typeAlarm': 'الثالث',
                    'dateTime': e.date.toString(),
                    'sentTime': e.sentTime.toString()
                  }
                ]);
              }
            }
//final formatter = Jiffy(timestamp).yMMMMEEEEdjm;
//Asmr-Max.OM5
            List<Map<String, dynamic>> margeArrays = [
              ...firstMap,
              ...nextMap,
              ...thirdMap,
            ];

            List<NotificationModel> result = margeArrays
                .map((e) => NotificationModel.fromJson(e))
                .cast<NotificationModel>()
                .toList();
            List<NotificationModel> forNotification = FilterPageNotification()
                .filterDataForScreenNotification(value: result);

            await Jiffy.locale("en");
            return forNotification;
          } else {
            // this is for first alarm notification
            showingNotifications(
              isWhenAppIsTerminated: isWhenAppIsTerminated,
              list: first,
              differenceHours: 144,
              typeAlarm: 'الاول',
            );

            // this is for next alarm notification
            showingNotifications(
              isWhenAppIsTerminated: isWhenAppIsTerminated,
              list: next,
              differenceHours: 1224,
              typeAlarm: 'الثاني',
            );

            // this is for third alarm notification
            showingNotifications(
              isWhenAppIsTerminated: isWhenAppIsTerminated,
              list: third,
              differenceHours: 2304,
              typeAlarm: 'الثالث',
            );
          }
        } else {
          // AppTerminated.whineAppIsTerminated(
          //     id: DateTime.now().microsecond,
          //     accuseName: 'value database equal null ',
          //     title: 'value database equal null ');
        }
        return null;
      });
    } catch (e) {
      ErrorResponse.showToastWidget(error: 'Error==> filterData $e ');
    }
    return null;
  }

  // /* this is for update data When Alarm Ends */
  Future<dynamic> update({
    required int id,
    required String typeAlarm,
    required String sentTime,
  }) async {
    return await DBHelper.updateWhenAlarmEnd(
      id: id,
      typeAlarm: typeAlarm,
      sentTime: sentTime,
    );
  }

  void showingNotifications({
    required List<Accused> list,
    required int differenceHours,
    required String typeAlarm,
    required bool isWhenAppIsTerminated,
  }) async {
    if (list.isNotEmpty) {
      try {
        String alarmType;
        if (typeAlarm == 'الاول') {
          alarmType = 'firstAlarm';
        } else if (typeAlarm == 'الثاني') {
          alarmType = 'nextAlarm';
        } else if (typeAlarm == 'الثالث') {
          alarmType = 'thirdAlert';
        } else {
          alarmType = '';
        }

        for (var e in list) {
          //this is for translation date to language arabic
          final formatter = Jiffy(e.date).yMMMMEEEEdjm;
          final formatterToDay = Jiffy(e.date).jm;

          // This is for difference By Days
          String differenceByDays = getDifferenceDateByDays(
              date: e.date.toString(), differenceHours: differenceHours);

          // This is for difference By Hours
          String differenceByHours = getDifferenceDateByHours(
              date: e.date.toString(), differenceHours: differenceHours);
          // This is for update user data When Alarm Ends

          // if (isWhenAppIsTerminated == false) {
            AppBackgroundFetch.whineAppIsBackground(
                    accuseName: e.name.toString(),
                    id: e.id!,
                    title: int.parse(differenceByHours) >= 0
                        ? ' تم انهاء التنبية $typeAlarm ${'حاليا'}  تاريخ دخولة في $formatter'
                        : ' سينتهي التنبية $typeAlarm ${differenceByDays == '0' ? 'اليوم' : 'غداً'} الساعة $formatterToDay تاريخ دخولة في $formatter')
                .then((value) async {
              await Jiffy.locale("en");
            });
          // } else {
            // AppTerminated.whineAppIsTerminated(
            //         accuseName: e.name.toString(),
            //         id: int.parse(e.id.toString()),
            //         title: int.parse(differenceByHours) >= 0
            //             ? ' تم انهاء التنبية $typeAlarm ${'حالياً'}  تاريخ دخولة في $formatter'
            //             : ' سينتهي التنبية $typeAlarm ${differenceByDays == '0' ? 'اليوم' : 'غداً'} الساعة $formatterToDay تاريخ دخولة في $formatter')
            //     .then((value) async {
            //   await Jiffy.locale("en");
            // });
            // AppBackgroundFetch.whineAppIsBackground(
            //   accuseName: e.name.toString(),
            //   id: e.id!,
            //   title: 'najeeb Firebase When app is terminated',
            // );
          // }

          if (int.parse(differenceByHours) >= 0) {

            await update(
                id: e.id!,
                typeAlarm: alarmType.toString(),
                sentTime: DateTime.now().toString());
            //This is for increment count notification
            NavigationService.instance.navigationKey.currentContext
                ?.read<HomeScreenProvider>()
                .incrementCountNotification(int.parse(list.length.toString()));
          } else {}

          //This is for increment count notification
          // NavigationService.instance.navigationKey.currentContext
          //     ?.read<HomeScreenProvider>()
          //     .incrementCountNotification(int.parse(list.length.toString()));
        }
      } catch (e) {
        AppTerminated.whineAppIsTerminated(
            id: DateTime.now().microsecond,
            accuseName: 'Error==>   showingNotifications  $e',
            title: '$e');
        ErrorResponse.showToastWidget(
            error: 'Error==>   showingNotifications  $e');
      }
    } else {
      // ErrorResponse.showToastWidget(
      //     error: 'Error===>>Alarm $typeAlarm is empty');
    }
  }

  // this is for get  difference date is alarm tody ro tomorrow by difference days
  String getDifferenceDateByDays(
      {required int differenceHours, required String date}) {
    DateTime now = DateTime.now();

    DateTime dateNow = DateTime(
      now.year,
      now.month,
      now.day,
    );
    var pars = DateTime.parse(date.toString());
    DateTime valueDate = DateTime(
      pars.year,
      pars.month,
      pars.day,
    );
    String firstAlarm = dateNow
        .difference(valueDate.add(Duration(hours: differenceHours)))
        .inDays
        .toString();

    return firstAlarm;
  }

  // this is for get  difference date is alarm tody ro tomorrow by difference hours
  String getDifferenceDateByHours(
      {required int differenceHours, required String date}) {
    DateTime now = DateTime.now();

    DateTime dateNow = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
    );
    DateTime pars = DateTime.parse(date.toString());
    DateTime valueDate = DateTime(
      pars.year,
      pars.month,
      pars.day,
      pars.hour,
    );

    String firstAlarm = dateNow
        .difference(valueDate.add(Duration(hours: differenceHours)))
        .inHours
        .toString();
    return firstAlarm;
  }
}
