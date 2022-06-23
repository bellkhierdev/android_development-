//version 1.0.0+1
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:provider/provider.dart';
import '../../export.dart';

class LocalAuthProvider with ChangeNotifier {
  int? _selectedWidget;
  int? get selectedWidget => _selectedWidget;

  bool _isAuthenticating = false;
  bool get isAuthenticating => _isAuthenticating;
  bool? _isFingerprint;
  bool? get isFingerprint => _isFingerprint;

  String _authorized = 'Not Authorized';
  String? get authorized => _authorized;

  _SupportState _supportState = _SupportState.unknown;

  _SupportState? get supportState => _supportState;

  final LocalAuthentication auth = LocalAuthentication();

  Future<bool>? checkSupported() {
    auth.isDeviceSupported().catchError((error) {
      return ErrorResponse.showToastWidget(
        error: '$error',
        colorShowToast: Colors.redAccent,
      );
    }).onError((error, stackTrace) {
      return ErrorResponse.showToastWidget(
        error: '$error',
        colorShowToast: Colors.redAccent,
      );
    }).then((bool isSupported) {
      if (isSupported) {
        return _supportState = _SupportState.supported;
      } else {
        return _supportState = _SupportState.unsupported;
      }
    }).then((value) => authenticate().onError((error, stackTrace) {
          return ErrorResponse.showToastWidget(
            error: '$error',
            colorShowToast: Colors.redAccent,
          );
        }).catchError((error) {
          return ErrorResponse.showToastWidget(
            error: '$error',
            colorShowToast: Colors.redAccent,
          );
        }));
    return null;
  }

  Future<void> authenticate() async {
    if (NavigationService.instance.navigationKey.currentContext!
            .read<LocalAuthProvider>()
            .isFingerprint ==
        true) {
      if (_supportState == _SupportState.supported &&
          _authorized != 'Authorized') {
        bool authenticated = false;
        try {
          _isAuthenticating = true;
          _authorized = 'Authenticating';
          notifyListeners();
          authenticated = await auth.authenticate(
              localizedReason: 'دع نظام التشغيل يحدد طريقة المصادقة',
              options: const AuthenticationOptions(
                useErrorDialogs: true,
                stickyAuth: true,
                //najeeb new
                biometricOnly: true,
              ),
              authMessages: const <AuthMessages>[
                AndroidAuthMessages(
                  signInTitle: 'امسح بصمة إصبعك (أو وجهك) للمصادقة',
                  biometricHint: 'تحقق من الهوية',
                  cancelButton: 'ًلا شكراً',
                ),
                IOSAuthMessages(
                  cancelButton: 'ًلا شكراً',
                ),
              ]);

          _isAuthenticating = false;

          notifyListeners();
        } on PlatformException catch (e) {

          _isAuthenticating = false;
          _authorized = 'Error - ${e.message}';

          notifyListeners();
          if (e.message.toString() ==
              'The operation was canceled because the API is locked out due to too many attempts. This occurs after 5 failed attempts, and lasts for 30 seconds.') {
            ErrorResponse.showToastWidget(
              error:
                  'لقد اجريت العديد من المحاولات، يرجى المحاولة بعد 30 ثانية',
              colorShowToast: Colors.redAccent,
            );
          }

          return;
        }

        if (authenticated) {
          notifyListeners();
          _authorized = 'Authorized';
          //This is for  Navigation without context
          NavigationService.instance.navigationKey.currentState
              ?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const NavigationBarScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          _authorized = ' Not Authorized';
          notifyListeners();
        }
      } else {
        ErrorResponse.customAwesomeDialog(
          'بالفعل نم مصادقتك',
          NavigationService.instance.navigationKey.currentContext,
          DialogType.SUCCES,
        );
        ErrorResponse.showToastWidget(
          error: 'بالفعل نم مصادقتك',
          colorShowToast: Colors.green,
        );
      }
    }
  }

  Future<void> cancelAuthentication() async {
    await auth.stopAuthentication();
    _isAuthenticating = false;
    notifyListeners();
  }

// get value of fingerprint from SharedPreferences
  Future<bool?> getDataLocalAuth() async {
    var value = await FuSharedPreferences.getBool('fingerprint');
    notifyListeners();
    return _isFingerprint = value;
  }

  //This is for check if user already enable fingerprint  or no
  void checkLocalAuth() async {
    var getFingerprint = await FuSharedPreferences.getBool('fingerprint');
    if (getFingerprint == null) {
      await FuSharedPreferences.setBool('fingerprint', true);
      _isFingerprint = true;
    } else if (getFingerprint == false) {
      await FuSharedPreferences.setBool('fingerprint', true);
      _isFingerprint = true;
    } else if (getFingerprint == true) {
      await FuSharedPreferences.setBool('fingerprint', false);
      _isFingerprint = false;
    } else {
    }

    notifyListeners();
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
