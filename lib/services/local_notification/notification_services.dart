//version 1.0.0+1

import 'package:issue/export.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotifyHelper {

   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

   initializeNotification() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // await UtilsLocalNotification().configureLocalTimezone();

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification:
            UtilsLocalNotification().onDidReceiveLocalNotification
            
            );

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher",);


    final InitializationSettings initializationSettings =InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: UtilsLocalNotification().selectNotification);
  }

  Future<void> scheduledNotification({
    required int id,
    required DateTime dateTime,
    required String name,
    required String title,

  }) async {
  

    DateTime dateTimePM = DateTime(
        dateTime.year, dateTime.month, dateTime.day, 20); //this is = 08:00 PM
    DateTime dateTimeAM = DateTime(
        dateTime.year, dateTime.month, dateTime.day, 7); //this is = 07:00 AM

    /* ------------------------ This is Notification for First week --------------------------------------------- */

    //this is for test notification

     UtilsLocalNotification().scheduledNotificationFunction(
      id: id,
      dateTime: DateTime.now().add(const Duration(seconds: 3)),
      //.add(const Duration(seconds: 3)),
      name: name,
      title: title,
      // ' سينتهي التنبية التجريبي ل $name  الساعة ${customTimes(dateTimePM.toString(), 2304)}  تاريخ دخولة في ${''.splitsDate(dateTime.toString())}',
      // issue: issue,
      // note: note.toString()
    );

//     //BEFORE EXPIRATION NOTIFICATION ONE DAY
//     await UtilsLocalNotification().scheduledNotificationFunction(
//         id: id + 2,
//         //This alert for the first week added 132 and 132 hours, which equals 6 days, and the reason is not counting the day on which the customer added this notification
//         dateTime: dateTime.add(const Duration(hours: 144))
//             //I took 24 hours from the previous date, which means one day, in order for the first notification to appear one day before the end of the charge
//             .subtract(const Duration(hours: 24)),
//         name: name,
//         date: ' سينتهي التنبية الاول ل $name يوم غداً  تاريخ دخولة في ${''.splitsDate(dateTimePM.toString())}',
//         issue: issue,
//         note: note.toString());

//   // PUSH NOTIFICATION FIRST WEEK IN THE SAME DAYS

//     await UtilsLocalNotification().scheduledNotificationFunction(
//         id: id + 3,
//         dateTime:dateTime.add(const Duration(hours: 144)), // This is equal 6 days
//         name: name,
//         date:' سينتهي التنبية الاول ل $name  الساعة ${customTimes(dateTimeAM.toString(), 144)}  تاريخ دخولة في ${''.splitsDate(dateTimePM.toString())}',
//         issue: issue,
//         note: note.toString());

//     /* ------------------------   This is Notification for First 45 day --------------------------------------------- */

//   //BEFORE EXPIRATION NOTIFICATION ONE DAY
//  /* this is push notification for The 45th day after the first week has passed */

//     await UtilsLocalNotification().scheduledNotificationFunction(
//         id: id + 4,
//         dateTime: dateTime
//             .add(const Duration(hours: 1224))

//             ///24 hours have been decreased because this alert will be one day before the notification expires
//             .subtract(const Duration(hours: 24)),
//         name: name,
//         date:
//             ' سينتهي التنبية الثاني ل $name يوم غداً  تاريخ دخولة في ${''.splitsDate(dateTimePM.toString())}',
//         issue: issue,
//         note: note.toString());

//   //PUSH NOTIFICATION FIRST 45 DAYS IN THE SAME DAYS
//   /*this is push notification for The 45th day after the first week has passed*/
//     await UtilsLocalNotification().scheduledNotificationFunction(
//         id: id + 5,
//         dateTime: dateTime.add(const Duration(hours: 1224)),
//         name: name,
//         date:
//             ' سينتهي التنبية الثاني ل $name  الساعة ${customTimes(dateTimeAM.toString(), 1224)}  تاريخ دخولة في ${customTimes(dateTimePM.toString(), 1224)}',
//         issue: issue,
//         note: note.toString());

// /* ------------------------   This is Notification for Next 45 day  --------------------------------------------- */

//   //BEFORE EXPIRATION NOTIFICATION ONE DAY
//   /* this is push notification for The 45th day after the first 45th day has passed */
//     await UtilsLocalNotification().scheduledNotificationFunction(
//         id: id + 6,
//         dateTime: dateTime.add(const Duration(hours: 2304))
//             //24 hours have been decreased because this alert will be one day before the notification expires
//             .subtract(const Duration(hours: 24)),
//         name: name,
//         date:
//             ' سينتهي التنبية الثالث ل $name يوم غداً  تاريخ دخولة في ${''.splitsDate(dateTimePM.toString())}',
//         issue: issue,
//         note: note.toString());

//   //PUSH NOTIFICATION AFTER THE  FIRST 45 DAYS ON THE SAME DAYS
//   /*this is push notification for The 45th day after the first 45th day has passed*/
//     await UtilsLocalNotification().scheduledNotificationFunction(
//         id: id + 7,
//         dateTime: dateTime.add(const Duration(hours: 2304)),
//         name: name,
//         date:
//             ' سينتهي التنبية الثالث ل $name  الساعة ${customTimes(dateTimePM.toString(), 2304)}  تاريخ دخولة في ${''.splitsDate(dateTime.toString())}',
//         issue: issue,
//         note: note.toString());
  }

//------------this is for get time for example ===> 7:00 AM----------//
  customTimes(dateTime, int number) {
    return ''
        .differentTime(dateTime.toString(), number)
        .toString()
        .split('|')[4]
        .toString();
  }
}
