//version 1.0.0+1
import 'package:flutter/services.dart';
import 'package:issue/export.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/buckup/backup_automatically.dart';
import '../filter_data/filter.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({Key? key}) : super(key: key);

  @override
  GSMainScreenState createState() => GSMainScreenState();
}

class GSMainScreenState extends State<NavigationBarScreen> {
  final globalScaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  //this is refresh screen when click button
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // ignore: prefer_typing_uninitialized_variables
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    UtilsLocalNotification().requestIOSPermissions();
  }

  late NavigationBarScreenTheme navigationBarTheme;

  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    themeData = Theme.of(context);
    //this is all screens
    final List<Widget> pages = [
      const HomeScreen(),
      const FilterHomeScreen(),
      const AddAccusedScreen(
        accused: null,
      ),
      SettingScreen(
        root: context,
      )
    ];

    systemTheme(themeData);

    return Consumer<FuAppThemeNotifier>(builder:
        (BuildContext context, FuAppThemeNotifier value, Widget? child) {
      navigationBarTheme = getNavigationThemeFromMode();

      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: FuAppTheme.getThemeFromThemeMode(),
          home: SafeArea(
            child: Scaffold(
              key: globalScaffoldKey,
              body: pages[currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: FuAppTheme.isDarkMode
                    ? themeData.scaffoldBackgroundColor
                    : Colors.white,
                // showSelectedLabels: false,/* this is for hide label title NavigationBarScreen */
                // showUnselectedLabels: false,/* this is for hide label title NavigationBarScreen */
                currentIndex: currentIndex,
                onTap: onTabTapped,
                type: BottomNavigationBarType.fixed,
                selectedIconTheme:
                    const IconThemeData(color: Color(0xff3d63ff)),
                unselectedIconTheme: IconThemeData(color: Colors.grey[300]),
                selectedItemColor: FuAppTheme.isDarkMode
                    ? const Color(0xFFFFFFFF)
                    : Colors.black,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                items: <BottomNavigationBarItem>[
                  //this is home page
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home, color: Colors.grey[700]),
                      activeIcon: const Icon(
                        Icons.home,
                        color: Color(0xff3d63ff),
                      ),
                      label: "الصفحة الرئيسية"),

                  //this is page filter
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.filter_alt,
                        color: Colors.grey[700],
                      ),
                      activeIcon: const Icon(
                        Icons.filter_alt,
                        color: Color(0xff3d63ff),
                      ),
                      label: "الفلترة"),

                  //this is page add Issue
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_box,
                      color: Colors.grey[700],
                    ),
                    activeIcon: const Icon(
                      Icons.add_box,
                      color: Color(0xff3d63ff),
                    ),
                    label: "اظافة متهم",
                  ),

                  //this is page Settings
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.grey[700],
                    ),
                    label: "الاعدادات",
                    activeIcon: const Icon(
                      Icons.settings,
                      color: Color(0xff3d63ff),
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}

//system theme for NavigationBar and Bar
systemTheme(themeData) {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        //this is for Theme NavigationBar
        systemNavigationBarColor: FuAppTheme.isDarkMode == false
            ? Colors.white
            : themeData.scaffoldBackgroundColor,
        systemNavigationBarDividerColor: FuAppTheme.isDarkMode == false
            ? Colors.white
            : themeData.scaffoldBackgroundColor,
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarIconBrightness:
            FuAppTheme.isDarkMode == false ? Brightness.dark : Brightness.light,
        //this is for Theme AppBar
        statusBarColor: FuAppTheme.isDarkMode == false
            ? Colors.white
            : themeData.scaffoldBackgroundColor,
        statusBarIconBrightness:
            FuAppTheme.isDarkMode == false ? Brightness.dark : Brightness.light,
        statusBarBrightness:
            FuAppTheme.isDarkMode == false ? Brightness.dark : Brightness.light,
      ),
    );
  });
}

NavigationBarScreenTheme getNavigationThemeFromMode() {
  NavigationBarScreenTheme navigationBarTheme = NavigationBarScreenTheme();
  if (FuAppTheme.isDarkMode == false) {
    navigationBarTheme.backgroundColor = Colors.white;
    navigationBarTheme.selectedItemColor = const Color(0xff3d63ff);
    navigationBarTheme.unselectedItemColor = const Color(0xff495057);
    navigationBarTheme.selectedOverlayColor = const Color(0x383d63ff);
  } else if (FuAppTheme.isDarkMode == true) {
    navigationBarTheme.backgroundColor = const Color(0xff37404a);
    navigationBarTheme.selectedItemColor = const Color(0xff37404a);
    navigationBarTheme.unselectedItemColor = const Color(0xffd1d1d1);
    navigationBarTheme.selectedOverlayColor = const Color(0xffffffff);
  }
  return navigationBarTheme;
}

class NavigationBarScreenTheme {
  Color? backgroundColor,
      selectedItemIconColor,
      selectedItemTextColor,
      selectedItemColor,
      selectedOverlayColor,
      unselectedItemIconColor,
      unselectedItemTextColor,
      unselectedItemColor;
}
