//version 1.0.0
import 'utils/firebase_notification.dart';
import 'utils/local_notification.dart';

class AppBackgroundFetch {
  static Future<void> whineAppIsBackground({
    required int id,
    required String accuseName,
    required String title,
  }) async {
    try {
      WhineFirebaseNotification.firebaseMessaging(
          id: id,
          accuseName: accuseName,
          title: title,
          dateTime:DateTime.now() );

    } catch (e) {
      WhineLocalNotification.localNotification(
        id: DateTime.now().microsecond,
        name: 'Error whineAppIsBackground $e',
        dateTime: DateTime.now(),
        title: title,
      
      );
    }
  }
}
