//version 1.0.0+1

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:issue/utils/funcation_globale.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:issue/export.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HealthActivityScreen extends StatefulWidget {
  final Accused? accused;

  const HealthActivityScreen({Key? key, required this.accused})
      : super(key: key);

  @override
  _HealthActivityScreenState createState() => _HealthActivityScreenState();
}

class _HealthActivityScreenState extends State<HealthActivityScreen>
    with RouteAware {
  late ThemeData themeData;

  Color? color1, color2, color3;
  @override
  initState() {
    super.initState();
    //------------IF DELETE THIS FUNCTION MAYBE DOING ERROR IN THE APPLICATION------------//
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await Jiffy.locale(
          "en"); //this is for translation date to language english
    });
    color1 = Colors.lightBlueAccent;
    color2 = Colors.purpleAccent;
    color3 = Colors.deepPurpleAccent;
  }

  @override
  void didPop() {
    // print('HomePage: Called didPop');
  }

  @override
  Widget build(BuildContext context) {
    String weekAlarm = ''.remainingDays(widget.accused!.date, 144).toString();

/* This is to see how much is left to alert in the first 45 day */
    String first45DayAlarm =
        ''.remainingDays(widget.accused!.date, 1224).toString();

/* This is to see how much is left to alert in the next 45 day*/
    String next45DayAlarm =
        ''.remainingDays(widget.accused!.date, 2304).toString();

    DateTime dateTime = DateTime.parse(
      widget.accused!.date.toString(),
    );
    var thisWeek = dateTime.add(const Duration(hours: 144));
    var firstNotification = dateTime.add(const Duration(hours: 1224));
    var nextNotification = dateTime.add(const Duration(hours: 2304));

    MySize().init(context);
    themeData = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          backgroundColor: FuAppTheme.isDarkMode == false
              ? Colors.white
              : themeData.scaffoldBackgroundColor,
          body: Container(
            color: FuAppTheme.isDarkMode
                ? Colors.black.withAlpha(60)
                : Colors.white,
            child: ListView(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    margin: Spacing.top(1.h),
                    padding: Spacing.right(1.w),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 15.sp,
                            color: FuAppTheme.isDarkMode == false
                                ? Colors.black
                                : FuAppTheme.customTheme.withe,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.accused!.name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: FuTextStyle.getStyle(
                                textStyle: themeData.textTheme.headline5,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 700),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: Spacing.top(0.1.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                      
                        height: 25.h,
                        child: CircularPercentIndicator(
                          backgroundColor: color1!.withAlpha(20),
                          lineWidth: 10,
                          radius: 20.h,
                          //140,
                          animation: true,
                          percent:
                              (weekAlarm.toString().split('|')[0].toDouble() -
                                      6.0) /
                                  6.0 *
                                  360.0.abs() *
                                  -1,
                          progressColor: color1,
                        ),
                      ),
                      SizedBox(
                        height: 33.h,
                        child: CircularPercentIndicator(
                          backgroundColor: color2!.withAlpha(20),
                          lineWidth: 10,
                          radius: 25.h,
                          animation: true,
                          animationDuration: 1000,
                          percent: (first45DayAlarm
                                      .toString()
                                      .split('|')[0]
                                      .toDouble() -
                                  51.0) /
                              51.0 *
                              360.0.abs() *
                              -1,
                          progressColor: color2,
                        ),
                      ),
                      Container(
                        height: 39.h,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: CircularPercentIndicator(
                          backgroundColor: color3!.withAlpha(20),
                          lineWidth: 10,
                          radius: 30.h,
                          animation: true,
                          animationDuration: 1000,
                          percent: (next45DayAlarm
                                      .toString()
                                      .split('|')[0]
                                      .toDouble() -
                                  96.0) /
                              96.0 *
                              360.0.abs() *
                              -1,
                          progressColor: color3,
                        ),
                      ),
                      SizedBox(
                        width: MySize.size120,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (double.parse((next45DayAlarm
                                                      .toString()
                                                      .split('|')[0]
                                                      .toDouble() -
                                                  96)
                                              .toString()) *
                                          (100 / 96) *
                                          -1)
                                      .toInt()
                                      .toString() +
                                  '%',
                              style: FuTextStyle.getStyle(
                                  fontSize: 16.sp,
                                  textStyle: themeData.textTheme.headline5,
                                  color: themeData.colorScheme.onBackground,
                                  fontWeight: 700),
                            ),
                            Text(
                              "من الوقت الكلي",
                              style: TextStyle(
                                fontFamily: StyleWidget.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                                letterSpacing: 0.0,
                                color: FuAppTheme.isDarkMode
                                    ? Colors.white
                                    : StyleWidget.grey.withOpacity(0.5),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: Spacing.fromLTRB(8.9.w, 1.h, 10.w, 0),
                  child: Column(
                    children: [
                      singleElement(
                          color: color1,
                          type: "الاول",
                          inGram: ''.replaceFarsiNumber(
                              '${''.splitsDate(thisWeek.toString())}'),
                          inPercentage: "".replaceFarsiNumber((double.parse(
                                      (weekAlarm
                                                  .toString()
                                                  .split('|')[0]
                                                  .toDouble() -
                                              6)
                                          .toString()) *
                                  (100 / 6) *
                                  -1)
                              .abs()
                              .toInt()
                              .toString())),
                      Container(
                        margin: Spacing.top(1.h),
                        child: singleElement(
                            color: color2,
                            type: "الثاني",
                            inGram: ''.replaceFarsiNumber(
                                '${''.splitsDate(firstNotification.toString())}'),
                            inPercentage: "".replaceFarsiNumber((double.parse(
                                        (first45DayAlarm
                                                    .toString()
                                                    .split('|')[0]
                                                    .toDouble() -
                                                51)
                                            .toString()) *
                                    (100 / 51) *
                                    -1)
                                .abs()
                                .toInt()
                                .toString())),
                      ),
                      Container(
                        margin: Spacing.top(5),
                        child: singleElement(
                            color: color3,
                            type: "الثالث",
                            inGram: ''.replaceFarsiNumber(
                                ' ${''.splitsDate(nextNotification.toString())} '),
                            inPercentage: "".replaceFarsiNumber((double.parse(
                                        (next45DayAlarm
                                                    .toString()
                                                    .split('|')[0]
                                                    .toDouble() -
                                                96)
                                            .toString()) *
                                    (100 / 96) *
                                    -1)
                                .abs()
                                .toInt()
                                .toString())),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: Spacing.fromLTRB(9.w, 5.h, 0, 0),
                  child: Text(
                    "إيقاف التنبيهات".toUpperCase(),
                    style: FuTextStyle.getStyle(
                        textStyle: themeData.textTheme.caption,
                        fontSize: 13.7.sp,
                        muted: true,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 600),
                  ),
                ),
                Container(
                  margin: Spacing.fromLTRB(6.w, 1.h, 6.w, 0),
                  child: Column(
                    children: [
                      singleActivity(
                          iconPlay: widget.accused?.isCompleted != 1
                              ? widget.accused?.firstAlarm == 1
                                  ? MdiIcons.play
                                  : MdiIcons.pause
                              : MdiIcons.play,
                          typeAlarm: 2,
                          iconData: MdiIcons.alarm,
                          color: color1!,
                          type: "إيقاف التنبية الاول",
                          time: FunctionGlobal.firstAlarm(
                              date: widget.accused!.date.toString())),
                      Container(
                        margin: Spacing.top(2.h),
                        child: singleActivity(
                            iconPlay: widget.accused?.nextAlarm == 1
                                ? MdiIcons.play
                                : MdiIcons.pause,
                            typeAlarm: 3,
                            iconData: MdiIcons.clockTimeThree,
                            color: color2!,
                            type: "إيقاف التنبية الثاني",
                            time: FunctionGlobal.nextAlarm(
                                date: widget.accused!.date.toString())),
                      ),
                      Container(
                        margin: Spacing.top(2.h),
                        child: singleActivity(
                            iconPlay: widget.accused?.thirdAlert == 1
                                ? MdiIcons.play
                                : MdiIcons.pause,
                            typeAlarm: 4,
                            iconData: MdiIcons.avTimer,
                            color: color3!,
                            type: "إيقاف التنبية الثالث",
                            time: FunctionGlobal.thirdAlarm(
                                date: widget.accused!.date.toString())),
                      ),
                      Container(
                        margin: Spacing.top(2.h),
                        child: singleActivity(
                            iconPlay: widget.accused?.isCompleted == 1
                                ? MdiIcons.play
                                : MdiIcons.pause,
                            typeAlarm: 1,
                            iconData: MdiIcons.timetable,
                            color: themeData.colorScheme.primary,
                            type: "إيقاف الكل",
                            time: "".replaceFarsiNumber("00 : 00")),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget singleElement(
      {Color? color,
      required String type,
      required String inGram,
      required String inPercentage}) {
    return Row(
      children: [
        Container(
          width: MySize.size12,
          height: MySize.size12,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(MySize.size4!))),
        ),
        Flexible(
          flex: 2,
          child: Container(
            margin: Spacing.left(16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    type,
                    style: FuTextStyle.getStyle(
                        textStyle: themeData.textTheme.bodyText1,
                        fontSize: 16,
                        fontWeight: 600,
                        color: themeData.colorScheme.onBackground),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Center(
                    child: AutoSizeText(
                      inGram,
                      maxLines: 2,
                      style: FuTextStyle.getStyle(
                          textStyle: themeData.textTheme.bodyText1,
                          fontSize: MySize.size20,
                          color: themeData.colorScheme.onBackground),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            inPercentage.length.toString() == '1' ? ' %' : '%',
                            style: FuTextStyle.getStyle(
                                textStyle: themeData.textTheme.subtitle2,
                                fontWeight: 600,
                                fontSize: MySize.size18,
                                color: themeData.colorScheme.onBackground),
                          ),
                          Text(
                            inPercentage,
                            style: FuTextStyle.getStyle(
                                textStyle: themeData.textTheme.subtitle2,
                                fontWeight: 600,
                                fontSize: MySize.size18,
                                color: themeData.colorScheme.onBackground),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget singleActivity(
      {IconData? iconData,
      IconData? iconPlay,
      required Color color,
      required String time,
      required int typeAlarm,
      required String type,
      bool? selected}) {
    return Container(
      padding: Spacing.all(8),
      decoration: BoxDecoration(
          color: FuAppTheme.isDarkMode == false
              ? Colors.white
              : Colors.black.withAlpha(60),
          borderRadius: BorderRadius.all(Radius.circular(MySize.size8!))),
      child: Row(
        children: [
          Container(
              padding: Spacing.all(6),
              decoration: BoxDecoration(
                  color: color.withAlpha(40),
                  borderRadius:
                      BorderRadius.all(Radius.circular(MySize.size4!))),
              child: Icon(
                iconData,
                color: color,
                size: MySize.size20,
              )),
          Expanded(
            child: Container(
              margin: Spacing.left(16),
              child: Text(
                type,
                style: FuTextStyle.getStyle(
                    textStyle: themeData.textTheme.bodyText2,
                    color: themeData.colorScheme.onBackground,
                    fontWeight: 500),
              ),
            ),
          ),
          Text(
            time.toString(),
            style: FuTextStyle.getStyle(
                textStyle: themeData.textTheme.subtitle2,
                fontWeight: 600,
                fontSize: MySize.size16,
                color: themeData.colorScheme.onBackground),
          ),
          Container(
            margin: Spacing.left(16),
            child: Icon(
              iconPlay,
              color: themeData.colorScheme.primary,
            ).onTap(() {
              if (iconPlay == MdiIcons.play) {
                ErrorResponse.showToastWidget(
                    error: 'بالفعل قد تم ايقاف التنبية مسبقاً',
                    textColor: StyleWidget.white);
              } else {
                selectTypeAlarmStop(
                  typeAlarm,
                  context,
                );
              }
            }),
          )
        ],
      ),
    );
  }

  dynamic selectTypeAlarmStop(
    int typeAlarm,
    BuildContext context,
  ) {
    String alarm = '';
    if (typeAlarm == 1) {
      alarm = 'التنبيهات كاملاً';
    } else if (typeAlarm == 2) {
      alarm = 'التنبية الاول';
    } else if (typeAlarm == 3) {
      alarm = 'التنبية الثاني';
    } else if (typeAlarm == 4) {
      alarm = 'التنبية الثالث';
    }
    return ErrorResponse.awesomeDialog(
      error: " سيتم إنهاء  $alarm",
      description: 'هل انت متاكد من ذالك',
      context: context,
      dialogType: DialogType.WARNING,
      color: Colors.blue,
      btnCancel: 'الغاء',
      btnOkOnPress: () async {
        await UtilsLocalNotification()
            .cancelNotificationById(widget.accused!.id!);

        setState(() {
          context.read<StateAccused>().accuseCompleted(
                widget.accused!.id!,
                context,
                typeAlarm,
              );
        });
      },
      btnCancelOnPress: () {},
    );
  }
}
