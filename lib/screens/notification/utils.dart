
//version 1.0.0+1
import 'package:firebase_messaging/firebase_messaging.dart';

class UtilsNotification {
  
  /// Maps a [AuthorizationStatus] to a string value.
  static Map<AuthorizationStatus, String> statusMap = {
    AuthorizationStatus.authorized: 'Authorized',
    AuthorizationStatus.denied: 'Denied',
    AuthorizationStatus.notDetermined: 'Not Determined',
    AuthorizationStatus.provisional: 'Provisional',
  };

  /// Maps a [AppleNotificationSetting] to a string value.
  static Map<AppleNotificationSetting, String> settingsMap = {
    AppleNotificationSetting.disabled: 'Disabled',
    AppleNotificationSetting.enabled: 'Enabled',
    AppleNotificationSetting.notSupported: 'Not Supported',
  };

  /// Maps a [AppleShowPreviewSetting] to a string value.
  static Map<AppleShowPreviewSetting, String> previewMap = {
    AppleShowPreviewSetting.always: 'Always',
    AppleShowPreviewSetting.never: 'Never',
    AppleShowPreviewSetting.notSupported: 'Not Supported',
    AppleShowPreviewSetting.whenAuthenticated: 'Only When Authenticated',
  };
}
