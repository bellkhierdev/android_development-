//version 1.0.0+1

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:issue/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:issue/export.dart';
import '../../services/manage_function_background/utils/local_notification.dart';
import 'PushNotificationsManager.dart';

class FirebaseApi {
//----------- This is for send notification to firebase------------------//

  Future<void> sendPushMessage({
    required String accuseName,
    required String title,
    required int id,
  }) async {
    
    PushNotificationsManager pushNotificationsManager =PushNotificationsManager();

    await pushNotificationsManager.init();

    String? fcmToken = await pushNotificationsManager.getToken();
   
    if (fcmToken == null) {
      FuLog('Unable to send FCM message, no token exists.');

      await NotifyHelper().initializeNotification();

      NotifyHelper().scheduledNotification(id: id, dateTime: DateTime.now(), name: accuseName, title: title);
      return;
    }
    
    try {
        await http.post(
        Uri.parse(Config.urlFirebaseMessaging),
        encoding: Encoding.getByName('utf-8'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${Config.serverKey}',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': title,
              'title': accuseName,
              'icon': 'ic_launcher',
              'color': '#8A51FB',
              'sound': 'notification.mp3'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': id.toString(),
              'status': 'done',
            },
            'to': fcmToken,
          },
        ),
      );
    log('send message$accuseName');
    } on SocketException {
   
      sendLocalNotification(accuseName: accuseName, id: id, title: title);
      return;
    } on HttpException {
   
      sendLocalNotification(accuseName: accuseName, id: id, title: title);

      return;
    } on FormatException {
   
      sendLocalNotification(accuseName: accuseName, id: id, title: title);

      return;
    } on TimeoutException {
 
      sendLocalNotification(accuseName: accuseName, id: id, title: title);

      return;
    } on Exception {
   
      sendLocalNotification(accuseName: accuseName, id: id, title: title);

      return;
    } catch (e) {
      await NotifyHelper().initializeNotification();
      sendLocalNotification(accuseName: accuseName, id: id, title: title);

      if (e is SocketException) {
        FuLog('الخادم غير متصل تأكد من اتصالك بالإنترنت ');
        return await UtilsLocalNotification().scheduledNotificationFunction(
          id: DateTime.now().microsecond,
          dateTime: DateTime.now().add(const Duration(seconds: 1)),
          name: '',
          title: 'الخادم غير متصل تأكد من اتصالك بالإنترنت ',
        );
      }

     
    }
  }

  sendLocalNotification({
    required String accuseName,
    required String title,
    required int id,
  }) {
    WhineLocalNotification.localNotification(
        id: id,
        name: accuseName,
        title: title,
        dateTime: DateTime.now().add(const Duration(seconds: 2)));
  }
}
