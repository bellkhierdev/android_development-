//version 1.0.0

import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:issue/export.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../main.dart';
import '../../services/buckup/backup_automatically.dart';
import '../../services/manage_function_background/utils/local_notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> with TickerProviderStateMixin {
  // ignore: prefer_typing_uninitialized_variables
  var _notifyHelper;

  //this is controller animation share data
  late AnimationController controller;

  static const List<IconData> icons = [
    MdiIcons.contentSaveEditOutline,
    MdiIcons.storeRemoveOutline,
    MdiIcons.deleteOutline,
    MdiIcons.close,
  ];

  static const List<String> iconsText = ["تعديل", "انهاء", "حذف  ", 'اغلاق'];
//this is for notification messaging form firebase
  late FirebaseMessaging messaging;
  dynamic token;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await NotifyHelper().initializeNotification();
    // Configure BackgroundFetch.
    await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 720, //This is equal 12 hours
            stopOnTerminate: false,
            enableHeadless: true,
            startOnBoot: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.

      ////------- Hear you can do anything ----------------////

      FilterDataForNotification().filterData(
          isWhenAppIsTerminated: false, loadForNotificationPage: false);

      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.

      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.

      ////------- Hear you can do anything ----------------////

      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      BackgroundFetch.finish(taskId);
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

 

  @override
  void initState() {
    super.initState();
    //------------THIS IS FOR DO BUCK UP TO GOOGLE DRIVE--------------//
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Timer.periodic(const Duration(hours: 4), (timer) {
        BackUpAutomatically().backupAutomatically(context: context);
      });
    });

    
    whenAppForGround();

    whenPressNotificationAndWhenAppIsTerminated();

    whenPressNotificationAndWhenAppIsBackground();

    initPlatformState();
    _notifyHelper = NotifyHelper();
    _notifyHelper .initializeNotification(); /* this is for  Initialize Notification Permissions Android And Ios*/
    UtilsLocalNotification().requestIOSPermissions();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  late ThemeData themeData;
  Widget? detailsIssue;

  @override
  Widget build(BuildContext context) {
    //  print('rebuild homeScreen');
    themeData = Theme.of(context);
    systemTheme(themeData);
    return Scaffold(
      backgroundColor:
          FuAppTheme.isDarkMode ? Colors.black.withAlpha(60) : Colors.white,
      floatingActionButton: detailsIssue,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          customAppBar(
            context,
          ),
        ],
        body: Center(
          child: Column(
            children: [
              Divider(
                height: 1.0,
                thickness: 0.5,
                color: FuAppTheme.isDarkMode
                    ? Colors.grey.withAlpha(150)
                    : Colors.black.withAlpha(50),
              ),
              _showIssue(),
            ],
          ),
        ),
      ),
    );
  }

  controllerUtilsIssue(data) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(icons.length, (int index) {
          Widget child = SizedBox(
            height: 70.0,
            width: MediaQuery.of(context).size.width,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: controller,
                curve: Interval(0.0, 1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOutQuint),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: MySize.size8!,
                        right: MySize.size8!,
                        top: MySize.size4!,
                        bottom: MySize.size4!),
                    margin: const EdgeInsets.only(right: 4),
                    color: const Color(0xFF0A4DC8),
                    child: Text(iconsText[index],
                        style: FuTextStyle.getStyle(
                            textStyle: themeData.textTheme.bodyText2,
                            color: StyleWidget.white,
                            fontWeight: 500,
                            letterSpacing: 0.2)),
                  ).onTap(() {
                    editStatusIssue(index, data);
                  }),
                  FloatingActionButton(
                    heroTag: null,
                    backgroundColor: FuAppTheme.isDarkMode
                        ? StyleWidget.darkText
                        : Colors.white,
                    mini: true,
                    child: Icon(icons[index],
                        color: FuAppTheme.isDarkMode
                            ? StyleWidget.white
                            : themeData.colorScheme.primary),
                    onPressed: () async {
                      await editStatusIssue(index, data);
                    },
                  ),
                ],
              ),
            ),
          );
          return child;
        }).toList());

    // });
  }

  //this is for show all Issue
  Widget _showIssue() {
    return SnapHelperWidget<List<Accused>?>(
        future: FilterProvider().getAccuse(context),
        loadingWidget: Padding(
          padding: const EdgeInsets.all(40.0),
          child: CircularProgressIndicator(color: context.theme.primaryColor),
        ),
        errorWidget: Padding(
          padding: const EdgeInsets.all(100.0),
          child: const NotFoundData(
            error: 'هناك خطاءً ما',
          ).center(),
        ),
        onSuccess: (List<Accused>? myData) {
          if (myData!.isEmpty) {
            return Center(
              child: const NotFoundData(
                error: '! ...لا توجد بيانات',
              ).paddingTop(30.h),
            );
          }

          return ListView.builder(
              padding: const EdgeInsets.all(0.0),
              itemCount: myData.length,
              itemBuilder: (BuildContext context, int index) {
                var data = myData[index];

                return GestureDetector(
                    onLongPress: () async {
                      detailsIssue = controllerUtilsIssue(myData[index]);
                      if (controller.isDismissed) {
                        setState(() {});
                        controller.forward();
                      } else {
                        setState(() {});
                        controller.reverse();
                      }
                    },
                    onTap: () {
                      controller.reverse();
                      navigateAccusedDetailsScreen(data);
                    },
                    child: UtilsHomeScreen(data, myData.length));
              }).paddingAll(5).expand();
          // }
        });
  }

  FutureOr onGoBack(dynamic value) async {
    await Jiffy.locale("en"); //this is for translation date to language english
    setState(() {});
  }

  void navigateAccusedDetailsScreen(data) async {
    await Jiffy.locale("en");
    Route route = CostumeTransition(AccusedDetailsScreen(
      accused: data,
      comingFromSearchPage: false,
    ));
    Navigator.push(context, route).then(onGoBack);
  }

  //this is onTap on text or icon card
  editStatusIssue(index, data) {
    //   print(iconsText[index]);

    //this is Edit Issue
    if (iconsText[index] == 'تعديل') {
      Navigator.push(
          context, CostumeTransition(AddAccusedScreen(accused: data)));
      controller.reverse();
    }

    //this is completed Issue
    if (iconsText[index] == 'انهاء') {
      ErrorResponse.awesomeDialog(
        error: ' انهاء تهمة  ${data.name!.split(' ')[0]}',
        context: context,
        dialogType: DialogType.QUESTION,
        color: Colors.red,
        btnCancel: 'الغاء',
        btnOkOnPress: () async {
          setState(() {
            context.read<StateAccused>().accuseCompleted(
                  data.id!,
                  context,
                  1,
                );
          });

          controller.reverse();
        },
        btnCancelOnPress: () {
          controller.reverse();
        },
      );
    }

    //this is delete Issue
    if (iconsText[index] == 'حذف  ') {
      return ErrorResponse.awesomeDialog(
          error: 'سوف يتم حذف  ${data.name!.split(' ')[0]}',
          context: context,
          dialogType: DialogType.QUESTION,
          color: Colors.red,
          btnCancel: 'الغاء',
          btnCancelOnPress: () {
            controller.reverse();
          },
          btnOkOnPress: () {
            setState(() {
              context.read<StateAccused>().delete(data);
            });
            controller.reverse();
          });
    }

    //this is close ftb
    if (iconsText[index] == 'اغلاق') {
      if (controller.isDismissed) {
        setState(() {});
        controller.forward();
      } else {
        setState(() {});
        controller.reverse();
      }
    }
  }

//this is for get data notification when app on open

  void whenAppForGround() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;

      AndroidNotification? android = message.notification?.android;
      if (android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // Najeeb Android 12
              // androidNotificationChannel.description,
              playSound: true,
              priority: Priority.high,
              importance: Importance.max,
              sound: RawResourceAndroidNotificationSound(android.sound),
              icon: 'ic_launcher',
              color: HexColor('#8A51FB'),
              // icon: '@mipmap/ic_launcher',
              // icon: 'ic_launcher',
              // icon: '@mipmap/ic_launcher',
              // color: FuAppTheme.theme.primaryColor,
              // largeIcon: const DrawableResourceAndroidBitmap('icon'),
              // ongoing: true, //This is in order for the user to be unable to ignore the notification except by pressing it and not dragging it
              styleInformation: const BigTextStyleInformation(''),
            ),
          ),
          payload: '${message.data['id']}',
        );
      }
    });
  }

  // Returns a [Stream] that is called when a user presses a notification message displayed via FCM.
  //A Stream event will be sent if the app has opened from a background state (not terminated).

  void whenPressNotificationAndWhenAppIsBackground() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //  log('A new onMessageOpenedApp event was published!');
      // log('getInitialMessage $message');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WhenPushNotified(
                  args: message,
                )),
      );
    });
  }

  // f the application has been opened from a terminated state via a [RemoteMessage]
  //(containing a [Notification]), it will be returned, otherwise it will be null.

  void whenPressNotificationAndWhenAppIsTerminated() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        // log('getInitialMessage $message');
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
