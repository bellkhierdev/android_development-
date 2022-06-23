//version 1.0.0+1
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:issue/export.dart';
import '../../main.dart';

class UtilsLocalNotification {
  Future<void> scheduledNotificationFunction({
    required int id,
    required DateTime dateTime,
    required String name,
    required String title,
  }) async {
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await displayNotification(
      id: id,
      dateTime: dateTime,
      name: name,
      title: title,
    );
  }

  displayNotification({
    required int id,
    required DateTime dateTime,
    required String name,
    required String title,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      id.toString(),
      name.toString(),
      // Najeeb Android 12
      // title.toString(),
      playSound: true,
      //  sound: const RawResourceAndroidNotificationSound('notification'),
      priority: Priority.high,
      importance: Importance.max,
      icon: 'ic_launcher',
     
      color: HexColor('#8A51FB'),
      // largeIcon: const DrawableResourceAndroidBitmap('icon'),
      // ongoing: true, //This is in order for the user to be unable to ignore the notification except by pressing it and not dragging it
      styleInformation: const BigTextStyleInformation(''),
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    // ----------- THIS IS NOT SCHEDULED NOTIFICATION AND NOT LIMITED-----------------//

    await flutterLocalNotificationsPlugin.show(
      id,
      name.toString(),
      title,
      platformChannelSpecifics,
      payload: id.toString(),
    );
  }

//----------this is Permissions platform Android and ios----------//
  void requestIOSPermissions() {
    /* this is for IOS */
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  //--------------this is for change theme-------------//
  Future selectNotification(String? payload, [BuildContext? context]) async {
    if (payload != null && payload.isNotEmpty) {
     // print('notification payload: $payload');
      NavigationService.instance.navigateToRoute(
          MaterialPageRoute(builder: (_) => WhenPushNotified(label: payload)));
    } else {
    //  print('payload = null');
    }
  }

//-------------- Get details on if the app was launched via a notification-----------//
  Future getNotificationAppLaunchDetail(id) async {
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

//this is for ios
  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
  }

//--------------this is for cancel Notification By Id----------------//
  Future cancelNotificationById(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
