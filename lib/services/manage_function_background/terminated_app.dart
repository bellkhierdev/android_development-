//version 1.0.0
import 'dart:developer';
import 'utils/local_notification.dart';

class AppTerminated {
 static  Future<void> whineAppIsTerminated(
      {required int id,
      required String accuseName,
      required String title,
      }) async {
  await  WhineLocalNotification.localNotification(
      id: id,
      name: accuseName,
      title: title,
      dateTime: DateTime.now(),
    );
  }
}


