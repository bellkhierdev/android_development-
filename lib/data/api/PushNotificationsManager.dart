
//Version 1.0.0+1

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => instance;

  static final PushNotificationsManager instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestPermission();
      _firebaseMessaging.setAutoInitEnabled(true);
      _initialized = true;
    }
  }

  Future<void> removeFCM() {
    return _firebaseMessaging.deleteToken();
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
