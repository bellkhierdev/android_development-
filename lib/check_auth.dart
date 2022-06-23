//version 1.0.0+1
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:issue/export.dart';
import 'package:flutter/material.dart';
import 'package:issue/services/local_Auth/fingerprint.dart';
import 'package:issue/services/local_Auth/state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/api/PushNotificationsManager.dart';
import 'screens/auth/onboarding.dart';
import 'screens/auth/welcome_page.dart';
import 'services/buckup/backup_automatically.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key}) : super(key: key);
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  String? token;
  bool initiate = true;
  bool? seen;
  bool? later;
  bool? open_app;
  bool? checkAccounts;

  @override
  void initState() {
    super.initState();
    initFCM();
  }

  initFCM() async {
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    await pushNotificationsManager.init();
  }

  @override
  Widget build(BuildContext context) {
    context.read<SettingProvider>().handleValueChange();
    var localAuth =
        context.read<LocalAuthProvider>().authorized.toString() != 'Authorized';
    context.read<LocalAuthProvider>().getDataLocalAuth();
    if (initiate) {
      //------- THIS IS FOR CHECK SOME VALIDATE WHEN START APPLICATION AND GO TO LOGIN OR WELL COME SCREEN -------//
      SharedPreferences.getInstance().then((value) async {
        // check if user login by test account or no
        await context.read<StateAuth>().isAccountTestIng();
        var checkAccount = await FuSharedPreferences.getBool(
          'TestAccount',
        );

        // if user not signIn going it to SignInScreen
        var userId = await FuSharedPreferences.getString('UserId');

        // if user saw Page WellCome not show  this Page  again
        var seenPageWellCome = await FuSharedPreferences.getBool('seen');

        // if user already is new client  show screen OnboardingPage
        var openApp = await FuSharedPreferences.getBool('openApp');

        setState(() {
          seen = seenPageWellCome;
          open_app = openApp;
          initiate = false;
          token = userId;
          checkAccounts = checkAccount;
        });
      });

      return const SplashScreen();
    } else {
      if (checkAccounts != null && checkAccounts == true) {
      
        return const WelcomePage();
      }
      if (open_app != true) {
        return const OnboardingPage();
      }
      if (later == true) {
        return const NavigationBarScreen();
      }

      if (seen != true&& checkAccounts == true) {
        return const WelcomePage();
      }

      if (token == null) {
        return const SignInScreen();
      } else {
        //This is for check if user already enable fingerprint if true show dialog Local Auth
        // else not enable fingerprint show screen NavigationBarScreen
        if (NavigationService.instance.navigationKey.currentContext!
                .read<LocalAuthProvider>()
                .isFingerprint ==
            true) {
          context.read<LocalAuthProvider>().checkSupported();

          if (localAuth) {
            return const NotAuthorized();
          } else {
            whenPressNotificationAndWhenAppIsTerminated();
            BackUpAutomatically().backupAutomatically(context: context);
            return const NavigationBarScreen();
          }
        } else {
          whenPressNotificationAndWhenAppIsTerminated();
          BackUpAutomatically().backupAutomatically(context: context);
          return const NavigationBarScreen();
        }
      }
    }
  }

  void whenPressNotificationAndWhenAppIsTerminated() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        FuLog('getInitialMessage $message');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WhenPushNotified(
                    args: message,
                  )),
        );
      }
    });
  }
}

//------- THIS IS SPLASH SCREEN -------//

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
