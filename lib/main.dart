//version 1.0.0+1

import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:issue/services/local_Auth/state.dart';
import 'package:provider/provider.dart';
import 'package:issue/export.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';

import 'config/config.dart';
import 'data/api/PushNotificationsManager.dart';

// [Android-only] This "Headless Task" is run when the Android app
// is terminated with enableHeadless: true
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  await DBHelper.initDB().then((value) async {
    await Firebase.initializeApp();

    //initFCM
    PushNotificationsManager pushNotificationsManager =
        PushNotificationsManager();
    await pushNotificationsManager.init();
    await NotifyHelper().initializeNotification();

    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    if (isTimeout) {
      //--------- You Can Return Any Function Here---------//

      // This task has exceeded its allowed running-time.
      // You must stop what you're doing and immediately .finish(taskId)
      FuLog("[BackgroundFetch] Headless task timed-out: $taskId");
      BackgroundFetch.finish(taskId);
      return;
    }

    FuLog('[BackgroundFetch] Headless event received.');

    //----- This Is for Filter Data And Get Accuse IS Completed And Return Notification For This Accuse ---//
    FilterDataForNotification().filterData(
        isWhenAppIsTerminated: true, loadForNotificationPage: false);

    BackgroundFetch.finish(taskId);
  });
}

//this is for get data notification when app on open

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  await Firebase.initializeApp(
    name: Config.nameProject,
    options: FirebaseOptions(
      apiKey: Config.serverKey,
      appId: Config.appId,
      messagingSenderId: Config.messagingSenderId,
      projectId: Config.projectId,
    ),
  );
  //This is for disable log  (print)
  FuLog.disable();

  await NotifyHelper().initializeNotification();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

// this is for start BackgroundFetch
  onClickEnable();

  await Jiffy.locale("en"); //this is for translation date to language english

//You will need to initialize AppThemeNotifier class for theme changes.
  FlutterUtilsProject.init();

  ///this is page Flutter Error Details
  FlutterErrorPage.flutterErrorDetails();
  log(DateTime.now().toString());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<FuAppThemeNotifier>(
        create: (_) => FuAppThemeNotifier(),
      ),
      ChangeNotifierProvider<FuAppThemeNotifier>(
        create: (_) => FuAppThemeNotifier(),
      ),
      ChangeNotifierProvider<FilterProvider>(
        create: (_) => FilterProvider(),
      ),
      ChangeNotifierProvider<StateAccused>(
        create: (_) => StateAccused(),
      ),
      ChangeNotifierProvider<HomeScreenProvider>(
        create: (_) => HomeScreenProvider(),
      ),
      ChangeNotifierProvider<StateAuth>(
        create: (_) => StateAuth(),
      ),
      ChangeNotifierProvider<SettingProvider>(
        create: (_) => SettingProvider(),
      ),
      ChangeNotifierProvider<LocalAuthProvider>(
        create: (_) => LocalAuthProvider(),
      ),
    ],
    child: FeatureDiscovery(
        recordStepsInSharedPreferences: false, child: const MyApp()),
  ));

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}

  await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (BuildContext context, Orientation orientation, deviceType) {
      return Consumer<FuAppThemeNotifier>(builder:
          (BuildContext context, FuAppThemeNotifier value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "مواعيد تمديدات الحبس الإحتياطي",
          theme: FuAppTheme.getThemeFromThemeMode(),
          navigatorKey: NavigationService.instance.navigationKey,
          initialRoute: "/",
          routes: {
            "/": (BuildContext context) => const CheckAuth(),
            "notifiedScreen": (BuildContext context) =>
                const WhenPushNotified(),
          },
        );
      });
    });
  }
}

void onClickEnable() {
  BackgroundFetch.start().then((status) {
    FuLog('Najeeb [BackgroundFetch] start success: $status');
  }).catchError((e) {
    FuLog('Error [BackgroundFetch] not start FAILURE: $e');
  });
}


// Add File google-services.json
// Add Server Key From Firebase Project
// Add App Id Form Firebase Project
// Add Messaging Sender Id From Firebase Project
// Add Project Id From Firebase Project
// Add Here Name Project From Firebase Project
// Add Private Key For Encrypt Data
// Change Icon App
// Change android:label From File AndroidManifest.xml

