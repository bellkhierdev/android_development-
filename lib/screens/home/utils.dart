//version 1.0.0+1

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:issue/export.dart';

class UtilsHomeScreen extends StatefulWidget {
  final Accused? accused;
  final int length;
  const UtilsHomeScreen(
    this.accused,
    this.length, {
    Key? key,
  }) : super(key: key);

  @override
  _BodeMain createState() => _BodeMain();
}

class _BodeMain extends State<UtilsHomeScreen> {
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context); //this is for initialize ThemeData
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 2,
          ),
          child: cardUsers(),
        ));
  }

  cardUsers() {
   // print(widget.accused!.date.toString());
    /* This is to see how much is left to alert in the first week */

    String weekAlarm = ''.remainingDays(widget.accused!.date, 144).toString();
    //this is for check validity data
    String checkeWeek = weekAlarm.toString().split('|')[1].toString();
/* This is to see how much is left to alert in the first 45 day */
    String first45DayAlarm =
        ''.remainingDays(widget.accused!.date, 1224).toString();
    //this is for check validity data
    String checkefirst45Day =
        first45DayAlarm.toString().split('|')[1].toString();

/* This is to see how much is left to alert in the next 45 day*/
    String next45DayAlarm =
        ''.remainingDays(widget.accused!.date, 2304).toString();
    // String checkeNext45Day = next45DayAlarm.toString().split('|')[1].toString();

    String name = widget.accused?.name.toString() ?? "";
    String issue = widget.accused?.accused.toString() ?? "";
    String date = widget.accused!.date.toString();
    // DateTime.now().year;
    DateTime dateTime = DateTime.parse(
      widget.accused!.date.toString(),
    );
    var thisWeek = dateTime.add(const Duration(hours: 144));
    var firstNoti = dateTime.add(const Duration(hours: 1224));
    var nextNoti = dateTime.add(const Duration(hours: 2304));
    themeData = Theme.of(context); //this is for initialize ThemeData
    return Card(
      shadowColor: Colors.black,
      color: FuAppTheme.isDarkMode
          ? themeData.scaffoldBackgroundColor
          : Colors.white,
      elevation: 5,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    rowDoubleText(name, 'الاسم: ', null),
                    rowDoubleText(issue, 'التهمة: ', null),
                    5.height,
                    rowDoubleText(''.replaceFarsiNumber(''.splitsDate(date)),
                        'تاريخ الدخول: ', 14.5),
                  ],
                ).expand(),
                name.length < 7
                    ? Container(
                        width: 90,
                      )
                    : Container(
                        width: 0,
                      ),
                //This Circle Animation
                Stack(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: <Widget>[
                    Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        color: FuAppTheme.isDarkMode
                            ? StyleWidget.cardDark.withAlpha(100)
                            : Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100.0),
                        ),
                        border: Border.all(
                            width: 4,
                            color: FuAppTheme.isDarkMode
                                ? StyleWidget.blue.withOpacity(0.1)
                                : StyleWidget.nearlyDarkBlue.withOpacity(0.2)
                                ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
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
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: StyleWidget.fontName,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: FuAppTheme.isDarkMode
                                  ? Colors.white
                                  : StyleWidget.nearlyDarkBlue,
                            ),
                          ),
                          Text(
                            'المدة الكاملة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: StyleWidget.fontName,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              letterSpacing: 0.0,
                              color: FuAppTheme.isDarkMode
                                  ? Colors.white
                                  : StyleWidget.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ).paddingOnly(bottom: 4, right: 5, top: 4, left: 0),
                    //
                    CustomPaint(
                      painter: CurvePainter(
                        colors: [
                          FuAppTheme.isDarkMode
                              ? StyleWidget.nearlyDarkBlue.withOpacity(0.9)
                              : StyleWidget.nearlyDarkBlue.withOpacity(0.9),
                          HexColor("#8A98E8"),
                          HexColor("#8A98E8"),
                        ],
                        angle: (next45DayAlarm
                                    .toString()
                                    .split('|')[0]
                                    .toDouble() -
                                96.0) /
                            96.0 *
                            360.0.abs() *
                            -1,
                      ),
                      child: const SizedBox(
                        width: 95,
                        height: 95,
                      ),
                    ),
                  ],
                ),
              ],
            ).paddingAll(MySize.size6!),
            2.height,
            Container(
              width: MediaQuery.of(context).size.width,
              height: FuAppTheme.isDarkMode == false ? 2.100 : 0.100,
              color: StyleWidget.background,
            ),
            5.height,
            // This is the all alarm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // This is the first alarm
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'التنبية الاول',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: StyleWidget.fontName,
                        fontSize: 13,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w600,
                        color: FuAppTheme.isDarkMode
                            ? StyleWidget.white
                            : StyleWidget.darkText,
                      ),
                    ),
                    Container(
                      height: 4,
                      width: 70,
                      decoration: BoxDecoration(
                        color: HexColor('#87A0E5').withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                      ),
                      child: Wrap(
                        children: <Widget>[
                          Container(
                            width:
                                (weekAlarm.toString().split('|')[0].toDouble() -
                                        6.0) /
                                    6.0 *
                                    70.0.abs() *
                                    -1,
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                HexColor('#87A0E5'),
                                HexColor('#87A0E5').withOpacity(0.5),
                              ]),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                            ),
                          )
                        ],
                      ),
                    ).paddingTop(4),
                    Text(
                      ''.replaceFarsiNumber(
                          '${''.splitsDate(thisWeek.toString())}'),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontFamily: StyleWidget.fontName,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: FuAppTheme.isDarkMode
                            ? StyleWidget.white.withAlpha(150)
                            : StyleWidget.grey.withOpacity(0.5),
                      ),
                    ).paddingTop(6),
                  ],
                ).expand(),

                // This is the second alarm
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'التنبية الثاني',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: StyleWidget.fontName,
                            fontSize: 13,
                            letterSpacing: -0.2,
                            fontWeight: FontWeight.w600,
                            color: FuAppTheme.isDarkMode
                                ? StyleWidget.white
                                : StyleWidget.darkText,
                          ),
                        ),
                        Container(
                          height: 4,
                          width: 70,
                          decoration: BoxDecoration(
                            color: HexColor('#F56E98').withOpacity(0.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                          ),
                          child: Wrap(
                            children: <Widget>[
                              Container(
                                width: (first45DayAlarm
                                            .toString()
                                            .split('|')[0]
                                            .toDouble() -
                                        51.0) /
                                    51.0 *
                                    70.0.abs() *
                                    -1,
                                height: 4,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    HexColor('#F56E98').withOpacity(0.7),
                                    HexColor('#F56E98'),
                                  ]),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          ''.replaceFarsiNumber(
                              '${''.splitsDate(firstNoti.toString())}'),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontFamily: StyleWidget.fontName,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: FuAppTheme.isDarkMode
                                ? StyleWidget.white.withAlpha(150)
                                : StyleWidget.grey.withOpacity(0.5),
                          ),
                        ).paddingTop(4),
                      ],
                    ),
                  ],
                ).expand(),

                // This is the third alarm
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'التنبية الثالث',
                          style: TextStyle(
                            fontFamily: StyleWidget.fontName,
                            fontSize: 13,
                            letterSpacing: -0.2,
                            fontWeight: FontWeight.w600,
                            color: FuAppTheme.isDarkMode
                                ? StyleWidget.white
                                : StyleWidget.darkText,
                          ),
                        ),
                        Container(
                          height: 4,
                          width: 70,
                          decoration: BoxDecoration(
                            color: HexColor('#F1B440').withOpacity(0.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                          ),
                          child: Wrap(
                            children: <Widget>[
                              Container(
                                width: (next45DayAlarm
                                            .toString()
                                            .split('|')[0]
                                            .toDouble() -
                                        96.0) /
                                    96.0 *
                                    70.0.abs() *
                                    -1,
                                height: 4,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    HexColor('#F1B440').withOpacity(0.7),
                                    HexColor('#F1B440'),
                                  ]),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                              ),
                            ],
                          ),
                        ).paddingTop(4),
                        Row(
                          children: [
                            Text(
                              ''.replaceFarsiNumber(
                                  ' ${''.splitsDate(nextNoti.toString())} '),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontFamily: StyleWidget.fontName,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: FuAppTheme.isDarkMode
                                    ? StyleWidget.white.withAlpha(150)
                                    : StyleWidget.grey.withOpacity(0.5),
                              ),
                            ).paddingTop(6),
                          ],
                        ),
                      ],
                    ),
                  ],
                ).expand(),
              ],
            ).paddingOnly(left: 10, right: 10, top: 5),
            10.height,
          ],
        ),
      ).paddingOnly(left: 7, right: 7, bottom: 0),
    );
  }

//This is OPP Row cuntant to Text
  rowDoubleText(data, text, double? myFalse) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Text(text.length > 22 ? text.substring(0, 20) + '...' : text,
              textAlign: TextAlign.center,
              style: FuTextStyle.boldTextStyle(
                  size: 16, color: themeData.textTheme.bodyText1!.color)),
        ),
        Flexible(
          flex: 2,
          child: Text(data.length > 20 ? data.substring(0, 20) + '...' : data,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: FuTextStyle.boldTextStyle(
                  size: 16, color: themeData.textTheme.bodyText1!.color)),
        ),
      ],
    );
  }
}

//This is for change Curve Painter
class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({required this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    const gradient1 = SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = Paint();
    cPaint.shader = gradient1.createShader(rect);
    cPaint.color = Colors.white;
    cPaint.strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(const Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
