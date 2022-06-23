//version 1.0.0+1

import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:issue/screens/settings/about/constants.dart';
import 'package:sizer/sizer.dart';

class MyCustomWidget extends StatefulWidget {
  const MyCustomWidget({Key? key}) : super(key: key);

  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget> {
  bool isExpanded = true;
  bool isExpanded2 = true;
  bool isExpanded3 = true;
  bool isExpanded4 = true;
  bool isExpanded5 = true;
  bool isExpanded6 = true;
  bool isExpanded7 = true;
  bool isExpanded8 = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            expandedWidget(
              doRow: false,
              height: 9.h,
              height1: 50.h,
              tapToExpandIt: Constants.introduction,
              sentence: Constants.introductionDetails,
              color: const Color(0xff6F12E8),
              shadowColor: const Color(0xff6F12E8).withOpacity(0.5),
              isExpanded2: isExpanded,
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
            expandedWidget(
              doRow: true,
              height: 9.h,
              height1: 30.h,
              tapToExpandIt: Constants.defendantSettings,
              sentence: Constants.defendantSettingsDetails,
              color: const Color(0xFF3E4BF8),
              shadowColor: const Color(0xFF3E4BF8).withOpacity(0.5),
              isExpanded2: isExpanded3,
              onTap: () {
                setState(() {
                  isExpanded3 = !isExpanded3;
                });
              },
            ),
            expandedWidget(
              doRow: true,
              height: 9.h,
              height1: 35.h,
              tapToExpandIt: Constants.search,
              sentence: Constants.searchDetails,
              color: const Color(0xFFC437D1),
              shadowColor: const Color(0xFFC437D1).withOpacity(0.5),
              isExpanded2: isExpanded4,
              onTap: () {
                setState(() {
                  isExpanded4 = !isExpanded4;
                });
              },
            ),
            expandedWidget(
              doRow: false,
              height: 9.h,
              height1: 35.h,
              tapToExpandIt: Constants.security,
              sentence: Constants.securityDetails,
              color: const Color(0xFF0D8B28),
              shadowColor: const Color(0xFF0D8B28).withOpacity(0.5),
              isExpanded2: isExpanded5,
              onTap: () {
                setState(() {
                  isExpanded5 = !isExpanded5;
                });
              },
            ),
            expandedWidget(
              doRow: false,
              height: 9.h,
              height1: 22.h,
              tapToExpandIt: Constants.shire,
              sentence: Constants.shireDetails,
              color: const Color(0xffFF5050),
              shadowColor: const Color(0xffFF5050).withOpacity(0.5),
              isExpanded2: isExpanded6,
              onTap: () {
                setState(() {
                  isExpanded6 = !isExpanded6;
                });
              },
            ),
            expandedWidget(
              doRow: false,
              height: 9.h,
              height1: 22.h,
              tapToExpandIt: Constants.alertsManagement,
              sentence: Constants.alertsManagementDetails,
              color: Color(0xFF006CB9),
              shadowColor: const Color(0xFF006CB9).withOpacity(0.5),
              isExpanded2: isExpanded7,
              onTap: () {
                setState(() {
                  isExpanded7 = !isExpanded7;
                });
              },
            ),
            expandedWidget(
              doRow: false,
              height: 9.h,
              height1: 35.h,
              tapToExpandIt: Constants.privacy,
              sentence: Constants.privacyDetails,
              color: Colors.deepOrange,
              shadowColor: Colors.deepOrange.withOpacity(0.5),
              isExpanded2: isExpanded2,
              onTap: () {
                setState(() {
                  isExpanded2 = !isExpanded2;
                });
              },
            ),
            expandedWidget(
              doRow: false,
              height: 9.h,
              height1: 35.h,
              tapToExpandIt: Constants.communicationAndSupport,
              sentence: Constants.communicationAndSupportDetails,
              color: Color(0xFF1472D0),
              shadowColor: Color(0xFF1472D0).withOpacity(0.5),
              isExpanded2: isExpanded8,
              onTap: () {
                setState(() {
                  isExpanded8 = !isExpanded8;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

//custom expanded widget
  InkWell expandedWidget(
      {required void Function()? onTap,
      required bool isExpanded2,
      required Color shadowColor,
      required String tapToExpandIt,
      required String sentence,
      required double height,
      required double height1,
      required bool doRow,
      required Color color}) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(
          horizontal: isExpanded2 ? 25 : 0,
          vertical: 10,
        ),
        // padding: const EdgeInsets.all(20),
        padding:  EdgeInsets.all(2.7.w),
        height: isExpanded2 ? height : height1,
        curve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(milliseconds: 1200),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 20,
              offset: const Offset(5, 10),
            ),
          ],
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(isExpanded2 ? 20 : 0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tapToExpandIt,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(
                    isExpanded2
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 27,
                  ),
                ],
              ),
              isExpanded2 ? const SizedBox() : const SizedBox(height: 20),
              AnimatedCrossFade(
                firstChild: const Text(
                  '',
                  style: TextStyle(
                    fontSize: 0,
                  ),
                ),
                secondChild: doRow
                    ? Row(
                        children: [
                          Text(
                            sentence,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.7.sp,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        sentence,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.7.sp,
                        ),
                      ),
                crossFadeState: isExpanded2
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 1200),
                reverseDuration: Duration.zero,
                sizeCurve: Curves.fastLinearToSlowEaseIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
