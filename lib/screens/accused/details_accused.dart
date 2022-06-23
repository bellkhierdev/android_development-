//version 1.0.0+1
import 'package:issue/export.dart';
import 'package:flutter/material.dart';
import 'package:issue/screens/accused/utils_accused.dart';
import 'package:issue/utils/funcation_globale.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AccusedDetailsScreen extends StatefulWidget {
  final Accused accused;
  final bool comingFromSearchPage;
  const AccusedDetailsScreen(
      {Key? key, required this.accused, required this.comingFromSearchPage})
      : super(key: key);
  @override
  IssuedDetailsScreenState createState() => IssuedDetailsScreenState();
}

class IssuedDetailsScreenState extends State<AccusedDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    localJiffy(); //this is for translation date to language english
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await Jiffy.locale(
          "en"); //this is for translation date to language english
    });
    checkIsCompletedIssue();
    // Check for phone call support.
    canLaunch('tel:123').then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  //this is for check issus is completed or no
  checkIsCompletedIssue() async {
    return await context
        .read<StateAccused>()
        .isCompleted(widget.accused.isCompleted!);
  }

  localJiffy() async {
    await Jiffy.locale("en");
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  late ThemeData themeData;
  bool _hasCallSupport = false;
  Future<void>? _launched;
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    // DateTime dateTime1 = DateTime.parse('2021-12-07 10:00:00.000');
    /* This is to see how much is left to alert in the first week */
    String weekAlarm = ''.remainingDays(widget.accused.date, 144).toString();
    //this is for check validity data
    String checkWeek = weekAlarm.toString().split('|')[1].toString();

    String resultWeek = checkWeek != '0'
        ? weekAlarm.toString().split('|')[0].toString() +
            weekAlarm.toString().split('|')[1].toString()
        : weekAlarm.toString().split('|')[0].toString();

    /* This is to see how much is left to alert in the first 45 day */
    String first45DayAlarm =
        ''.remainingDays(widget.accused.date, 1224).toString();
    //this is for check validity data
    String checkFirst45Day =
        first45DayAlarm.toString().split('|')[1].toString();

    String resultFirst = checkFirst45Day != '0'
        ? first45DayAlarm.toString().split('|')[0].toString() +
            first45DayAlarm.toString().split('|')[1].toString()
        : first45DayAlarm.toString().split('|')[0].toString();

    /* This is to see how much is left to alert in the next 45 day*/
    String next45DayAlarm =
        ''.remainingDays(widget.accused.date, 2304).toString();
    //this is for check validity data
    String checkeNext45Day = next45DayAlarm.toString().split('|')[1].toString();

    String resultNext = checkeNext45Day != '0'
        ? next45DayAlarm.toString().split('|')[0].toString() +
            next45DayAlarm.toString().split('|')[1].toString()
        : next45DayAlarm.toString().split('|')[0].toString();

    /* this is enter Issue */
    // String enter = ''.decodeDate(''.repliesDate1(, 0), 1);
    String enter = ''.myReplaceFarsiNumber(Jiffy(widget.accused.date).yMMMd);

    /* this is firs name and last name */
    String splitName = ''.nameAbbreviation(widget.accused.name.toString());

    DateTime dateTime = DateTime.parse(
      widget.accused.date.toString(),
    );

    var thisWeek = dateTime.add(const Duration(hours: 144));
    var firstNotification = dateTime.add(const Duration(hours: 1224));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: FuAppTheme.isDarkMode == false
                ? Colors.white
                : themeData.scaffoldBackgroundColor,
            body: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.comingFromSearchPage == false
                    ? topScreen(splitName, context)
                    : WidgetExtension.empty(),
                divider(),
                bodyScreen(
                        enter,
                        weekAlarm,
                        checkWeek,
                        thisWeek,
                        resultWeek,
                        first45DayAlarm,
                        checkFirst45Day,
                        firstNotification,
                        resultFirst,
                        context,
                        resultNext)
                    .paddingOnly(bottom: 10, right: 10, left: 10, top: 7),
              ],
            ))),
      ),
    );
  }

  Column bodyScreen(
      String enter,
      String weekAlarm,
      String checkWeek,
      DateTime thisWeek,
      String resultWeek,
      String first45DayAlarm,
      String checkFirst45Day,
      DateTime firstNotification,
      String resultFirst,
      BuildContext context,
      String resultNext) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 2,
                child: RichText(
                  text: TextSpan(
                    text: 'الاسم: ',
                    style: TextStyle(
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                        color: FuAppTheme.isDarkMode
                            ? StyleWidget.white
                            : StyleWidget.costmary,
                        fontWeight: FontWeight.w600),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.accused.name,
                        style: TextStyle(
                            fontSize: 20,
                            color: FuAppTheme.isDarkMode
                                ? StyleWidget.white
                                : Colors.black,
                            fontWeight: StyleWidget.fontWeight),
                      ),
                    ],
                  ),
                )),
          ],
        ),
        1.height,
        divider(),
        1.height,
        //this is for get enter date
        Row(
          children: [
            Flexible(
                flex: 2,
                child: RichText(
                  text: TextSpan(
                    text: 'منذ: ',
                    style: TextStyle(
                        fontSize: 18,
                        color: FuAppTheme.isDarkMode == false
                            ? StyleWidget.costmary
                            : StyleWidget.white,
                        fontWeight: FontWeight.w600),
                    children: <TextSpan>[
                      TextSpan(
                        text: enter.toString().split(', ۷ ص')[0].toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: FuAppTheme.isDarkMode == false
                                ? Colors.black
                                : StyleWidget.white,
                            fontWeight: StyleWidget.fontWeight),
                      ),
                    ],
                  ),
                )),
            8.width,
            Icon(
              MdiIcons.earth,
              size: MySize.size20,
              color: FuAppTheme.isDarkMode
                  ? StyleWidget.white.withAlpha(150)
                  : themeData.colorScheme.primary,
            ),
          ],
        ),

        divider(),
        Row(children: [
          Flexible(
              flex: 2,
              child: RichText(
                text: TextSpan(
                  text: 'التهمة: ',
                  style: TextStyle(
                      fontSize: 18,
                      color: FuAppTheme.isDarkMode
                          ? StyleWidget.white
                          : StyleWidget.costmary,
                      fontWeight: FontWeight.w600),
                  children: <TextSpan>[
                    TextSpan(
                      text: widget.accused.accused!,
                      style: TextStyle(
                          fontSize: 20,
                          color: FuAppTheme.isDarkMode
                              ? StyleWidget.white
                              : Colors.black,
                          fontWeight: StyleWidget.fontWeight),
                    ),
                  ],
                ),
              )),
        ]),

        divider(),
        1.height,
        //this is number Issue
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 1,
                child: RichText(
                  text: TextSpan(
                    text: 'رقم القضية: ',
                    style: TextStyle(
                        fontSize: 18,
                        color: FuAppTheme.isDarkMode == false
                            ? StyleWidget.costmary
                            : StyleWidget.white,
                        fontWeight: FontWeight.w600),
                    children: <TextSpan>[
                      TextSpan(
                        text: ''.replaceFarsiNumber(
                          widget.accused.issueNumber.toString(),
                        ),
                        style: TextStyle(
                            fontSize: 20,
                            color: FuAppTheme.isDarkMode == false
                                ? Colors.black
                                : StyleWidget.white,
                            fontWeight: StyleWidget.fontWeight),
                      ),
                    ],
                  ),
                )),
          ],
        ),

        // 4.height,
        widget.accused.note!.isNotEmpty ? divider() : const SizedBox(),
        // This is note
        widget.accused.note!.isNotEmpty
            ? Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: RichText(
                        text: TextSpan(
                          text: 'الملاحظة: ',
                          style: TextStyle(
                              fontSize: 18,
                              color: FuAppTheme.isDarkMode == false
                                  ? StyleWidget.costmary
                                  : StyleWidget.white,
                              fontWeight: FontWeight.w600),
                          children: <TextSpan>[
                            TextSpan(
                              text: ''.replaceFarsiNumber(
                                  widget.accused.note.toString()),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: FuAppTheme.isDarkMode == false
                                      ? Colors.black
                                      : StyleWidget.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )),
                  4.width,
                ],
              )
            : const SizedBox(),
        widget.accused.phoneNu.toString() != '0' ? divider() : Container(),
        widget.accused.phoneNu.toString() != '0'
            ? Row(
                children: [
                  Text("وكيل المتهم:",
                          style: TextStyle(
                              fontSize: 18,
                              color: FuAppTheme.isDarkMode
                                  ? StyleWidget.white
                                  : StyleWidget.costmary,
                              fontWeight: FontWeight.w600))
                      .expand(),
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(MySize.size28!),
                          side: BorderSide(
                            color: FuAppTheme.isDarkMode
                                ? StyleWidget.white
                                : themeData.colorScheme.primary,
                          )),
                      child: InkWell(
                        splashColor:
                            themeData.colorScheme.primary.withAlpha(100),
                        child: SizedBox(
                            width: MySize.size38,
                            height: MySize.size38,
                            child: Icon(
                              MdiIcons.phone,
                              color: FuAppTheme.isDarkMode
                                  ? StyleWidget.white
                                  : themeData.colorScheme.primary,
                              size: 16,
                            )),
                        onTap: (_hasCallSupport
                            ? () => setState(() {
                                  _launched = UtilsAccused.makePhoneCall(
                                      widget.accused.phoneNu.toString());
                                })
                            : null),
                      ),
                    ),
                  ),
                  20.width,
                  Container(
                    margin: Spacing.left(10),
                    child: ClipOval(
                      child: Material(
                        color: Colors.transparent, // button color
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(MySize.size28!),
                            side: BorderSide(
                              color: FuAppTheme.isDarkMode
                                  ? StyleWidget.white
                                  : themeData.colorScheme.primary,
                            )),
                        child: InkWell(
                            splashColor:
                                themeData.colorScheme.primary.withAlpha(100),
                            child: SizedBox(
                                width: MySize.size38,
                                height: MySize.size38,
                                child: Icon(
                                  //message_rounded
                                  MdiIcons.androidMessages,
                                  color: FuAppTheme.isDarkMode
                                      ? StyleWidget.white
                                      : themeData.colorScheme.primary,
                                  size: 16,
                                )),
                            onTap: () async {
                              //mounted
                              _hasCallSupport
                                  ? _launched = await UtilsAccused.smsMessage(
                                          widget.accused.phoneNu.toString())
                                      ?.then((value) {
                                      setState(() => _launched = value);
                                      return value;
                                    })
                                  : null;
                            }

                          
                            ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
        divider(),
        // 5.height,
        32.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //This is the first alarm

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("التنبية الاول".toUpperCase(),
                    style: FuTextStyle.boldTextStyle(
                        size: 14, color: themeData.textTheme.bodyText1!.color)),
                8.height,
                CircularPercentIndicator(
                  radius: 80,
                  animation: true,
                  animationDuration: 1000,
                  percent:
                      (weekAlarm.toString().split('|')[0].toDouble() - 6.0) /
                          6.0 *
                          360.0.abs() *
                          -1,
                  progressColor: StyleWidget.circleColor,
                  backgroundColor: HexColor('#87A0E5').withOpacity(0.2),
                  center: Text(
                    ''.replaceFarsiNumber(
                      checkWeek != '0'
                          ? weekAlarm.toString().split('|')[0].toString()
                          : 'مكتمل',
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            checkWeek != '0' ? MySize.size20 : MySize.size18),
                  ),
                ).onTap(() {}),
                8.height,
                Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff6F12E8).withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0.0, 0.0),
                        ),
                      ],
                      color: const Color(0xff6F12E8),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Column(children: [
                      3.height,
                      Text(
                          ''
                              .replaceFarsiNumber(
                                  '${''.splitsDate(thisWeek.toString())}')
                              .toUpperCase(),
                          textDirection: TextDirection.ltr,
                          style: FuTextStyle.boldTextStyle(
                              size: 14, color: StyleWidget.white)),
                      3.height,
                      Text(
                          FunctionGlobal.firstAlarm(
                              date: widget.accused.date.toString()),
                          // resultWeek.trim() == 'المدة مكتملة'
                          //     ? ''.replaceFarsiNumber(resultWeek)
                          //     : 'يتبقى:${''.replaceFarsiNumber(resultWeek)}',
                          style: FuTextStyle.boldTextStyle(
                            size: 14,
                            color: StyleWidget.white,
                          )),
                      3.height,
                    ]))
              ],
            ),
            //This is the second alarm
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("التنبية الثاني".toUpperCase(),
                    style: FuTextStyle.boldTextStyle(
                        size: 14, color: themeData.textTheme.bodyText1!.color)),
                5.height,
                CircularPercentIndicator(
                  radius: 80,
                  percent:
                      (first45DayAlarm.toString().split('|')[0].toDouble() -
                              51.0) /
                          51.0 *
                          360.0.abs() *
                          -1,
                  animationDuration: 1000,
                  animation: true,
                  progressColor: HexColor('#F56E98'),
                  backgroundColor: HexColor('#F56E98').withOpacity(0.2),
                  center: Text(
                    ''.replaceFarsiNumber(
                      checkFirst45Day != '0'
                          ? first45DayAlarm.toString().split('|')[0].toString()
                          : 'مكتمل',
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: first45DayAlarm != '0'
                            ? MySize.size20
                            : MySize.size18),
                  ),
                ).onTap(() {
                  // buildLightCustomizeDialog(context);
                }), //"65%"
                8.height,
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff6F12E8).withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0.0, 0.0),
                      ),
                    ],
                    color: const Color(0xff6F12E8),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      3.height,
                      Text(
                          ''
                              .replaceFarsiNumber(
                                  '${''.splitsDate(firstNotification.toString())}')
                              .toUpperCase(),
                          textDirection: TextDirection.ltr,
                          style: FuTextStyle.boldTextStyle(
                              size: 14, color: StyleWidget.white)),
                      3.height,
                      Text(
                        FunctionGlobal.nextAlarm(
                            date: widget.accused.date.toString()),
                        // resultFirst.trim() == 'المدة مكتملة'
                        //     ? ''.replaceFarsiNumber(resultFirst)
                        //     : 'يتبقى:${''.replaceFarsiNumber(resultFirst)}',
                        style: FuTextStyle.boldTextStyle(
                            size: 14, color: StyleWidget.white),
                      ),
                      3.height,
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        //This is the third alarm
        32.height,
        Text("التنبية الثالث".toUpperCase(),
                style: FuTextStyle.boldTextStyle(
                    color: themeData.textTheme.bodyText1!.color))
            .center(),
        16.height,
        SizedBox(
          height: 10,
          width: context.width * 0.7,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(
              children: [
                Container(
                  width: context.width * 0.7,
                  decoration: BoxDecoration(
                      color: HexColor('#87A0E5').withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16)),
                ),
                Container(
                  width:
                      ((resultNext.toString().split('يوم')[0].toDouble() - 96) /
                              96 *
                              context.width *
                              0.7)
                          .abs(),
                  decoration: BoxDecoration(
                      color: StyleWidget.circleColor,
                      borderRadius: BorderRadius.circular(16)),
                ),
              ],
            ),
          ),
        ).center(),
        8.height,
        Text(FunctionGlobal.thirdAlarm(date: widget.accused.date.toString()),
                // resultNext.trim() == 'المدة مكتملة'
                //     ? ''.replaceFarsiNumber(resultNext)
                //     : 'يتبقى:${''.replaceFarsiNumber(resultNext)}',
                style: FuTextStyle.boldTextStyle(
                    color: StyleWidget.circleColor, size: 14))
            .center(),
      ],
    );
  }

  Container topScreen(String splitName, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MySize.size0!,
          left: MySize.size0!,
          right: MySize.size0!,
          bottom: MySize.size0!),
      decoration: BoxDecoration(
          color: FuAppTheme.isDarkMode == false
              ? Colors.white
              : themeData.scaffoldBackgroundColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(MySize.size16!),
              topRight: Radius.circular(MySize.size16!))),
      child: Column(
        children: <Widget>[
          Row(
            textDirection: TextDirection.ltr,
            children: <Widget>[
              FuContainer.none(
                  borderRadius: BorderRadius.circular(MySize.size6!),
                  color: FuAppTheme.isDarkMode
                      ? StyleWidget.cardDark.withAlpha(200)
                      : Colors.grey[200],
                  shape: BoxShape.circle,
                  child: Image(
                    image: AssetImage(ImagesUrl.profile),
                    fit: BoxFit.cover,
                    height: MySize.size56,
                    width: MySize.size56,
                  )),
              Container(
                margin: EdgeInsets.only(left: MySize.size8!),
                child: Column(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      splitName.length > 22
                          ? splitName.substring(0, 20) + '...'
                          : splitName,
                      style: themeData.textTheme.subtitle1!.merge(
                        TextStyle(
                          color: themeData.colorScheme.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Consumer<StateAccused>(
                        builder: (context, provider, child) => Text(
                              provider.completed != 0 ? "موقف" : 'نشط',
                              style: themeData.textTheme.bodyText1!
                                  .merge(TextStyle(
                                fontWeight: FontWeight.w700,
                                color: provider.completed != 0
                                    ? Colors.red
                                    : StyleWidget.primaryClr,
                              )),
                            ))
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios,
                          size: 20,
                          color: themeData.textTheme.bodyText1!.color),
                    ),
                    const CircleAvatar(
                      backgroundColor: StyleWidget.circleColor,
                      radius: 14,
                      child: Icon(
                        Icons.keyboard_control,
                        color: Colors.white,
                      ),
                    ).onTap(() {
                      ShowBottomSheet.costumeBottomSheet(
                          accused: widget.accused,
                          context: context,
                          // controller: controller,
                          setState: setState,
                          key: 1,
                          themeData: themeData);
                    })
                  ],
                ),
              ),
            ],
          ),
        ],
      ).paddingOnly(top: 1.0, right: 5, left: 5, bottom: 1.0),
    );
  }
}
