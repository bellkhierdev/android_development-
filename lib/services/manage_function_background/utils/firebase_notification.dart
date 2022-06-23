//version 1.0.0

// send notification to firebase
import '../../../config/config.dart';
import '../../../export.dart';
import '../../../utils/internet.dart';
import 'local_notification.dart';

class WhineFirebaseNotification {
  static void firebaseMessaging({
    required String accuseName,
    required String title,
    required DateTime dateTime,
    required int id,
  }) async {
    try {
      final checkInternet = await CheckInternet.check(
        url: Config.checkInternetFirebase,
        timeout: 600,
      ).then((value) => value);
      if (checkInternet.isNotEmpty) {
        FirebaseApi()
            .sendPushMessage(accuseName: accuseName, title: title, id: id)
            .onError((error, stackTrace) {
          WhineLocalNotification.localNotification(
            id: id,
            name: '$error ',
            title: 'Error',
            dateTime: DateTime.now().add(const Duration(seconds: 2)),
          );
        });
      } else {
        WhineLocalNotification.localNotification(
          id: id,
          name: accuseName,
          title: title,
          dateTime: DateTime.now().add(const Duration(seconds: 2)),
        );
      }
    } catch (e) {
      WhineLocalNotification.localNotification(
        id: DateTime.now().microsecond,
        name: 'Error WhineFirebaseNotification',
        title: 'Error $e',
        dateTime: DateTime.now().add(const Duration(seconds: 1)),
      );

    }
  }
}
