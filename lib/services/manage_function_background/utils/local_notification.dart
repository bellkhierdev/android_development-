//version 1.0.0

// send local notification

import '../../../export.dart';

class WhineLocalNotification {
  static Future<void> localNotification({
    required int id,
    required String name,
    required DateTime dateTime,
    required String title,
  }) async {
    await NotifyHelper().initializeNotification();

    return NotifyHelper().scheduledNotification(id: id, dateTime: dateTime, name: name, title: title);
  }
}
