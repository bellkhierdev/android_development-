//version 1.0.0+1

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:issue/export.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class WhenPushNotified extends StatefulWidget {
  final label;

  final RemoteMessage? args;
  const WhenPushNotified({
    Key? key,
    this.label,
    this.args,
  }) : super(key: key);

  @override
  State<WhenPushNotified> createState() => _WhenPushNotifiedState();
}

class _WhenPushNotifiedState extends State<WhenPushNotified> {
  bool active = false;

  @override
  void initState() {
    super.initState();
    //------------IF DELETE THIS FUNCTION MAYBE DOING ERROR IN THE APPLICATION------------//
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await Jiffy.locale(
          "en"); //this is for translation date to language english
    });
  }

  @override
  Widget build(BuildContext context) {
    int? idUser;
    
    if (widget.label != null && widget.label.toString().isNotEmpty) {
      idUser = int.parse(widget.label.toString());
    } else {
      idUser = int.parse(widget.args?.data['id']);
    }

    repliesDate(label, int number) {
      return ''.differentTime(label.toString(), number);
    }

    late ThemeData themeData;
    themeData = Theme.of(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: FuAppTheme.isDarkMode == false
              ? Colors.white
              : themeData.scaffoldBackgroundColor,
          body: SnapHelperWidget<List<Accused>?>(
              future: FilterProvider().getAccuseById(
                  id: idUser), //this is for get the accused by id
              loadingWidget: Padding(
                padding: const EdgeInsets.all(40.0),
                child: CircularProgressIndicator(
                    color: context.theme.primaryColor),
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
                    ).paddingTop(context.width / 3),
                  );
                }

                return ListView.builder(
                    padding: const EdgeInsets.all(0.0),
                    itemCount: myData.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = myData[index];
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: MySize.size8!,
                                left: MySize.size16!,
                                right: MySize.size16!,
                                bottom: MySize.size20!),
                            decoration: BoxDecoration(
                                color: FuAppTheme.isDarkMode
                                    ? themeData.scaffoldBackgroundColor
                                    : Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(MySize.size16!),
                                    topRight: Radius.circular(MySize.size16!))),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  textDirection: TextDirection.ltr,
                                  children: <Widget>[
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            MySize.size6!),
                                        child: Image(
                                          image: AssetImage(ImagesUrl.profile),
                                          fit: BoxFit.cover,
                                          height: MySize.size56,
                                          width: MySize.size56,
                                        )),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: MySize.size8!),
                                      child: Column(
                                        textDirection: TextDirection.ltr,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            data.name.toString().length > 22
                                                ? data.name
                                                        .toString()
                                                        .substring(0, 20) +
                                                    '...'
                                                : data.name.toString(),
                                            style: themeData
                                                .textTheme.subtitle1!
                                                .merge(TextStyle(
                                                    color: FuAppTheme
                                                        .theme
                                                        .textTheme
                                                        .bodyText1!
                                                        .color,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          Text(
                                            active ? "موقف" : 'نشط',
                                            style: themeData
                                                .textTheme.bodyText1!
                                                .merge(TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: active
                                                  ? Colors.red
                                                  : StyleWidget.primaryClr,
                                            )),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: Icon(Icons.arrow_back_ios,
                                                color: themeData.textTheme
                                                    .bodyText1!.color),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ).paddingOnly(top: 20),
                          ),
                          //this head Issue details information

                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              text: data.name.toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: FuAppTheme.isDarkMode
                                                      ? StyleWidget.white
                                                      : StyleWidget.black,
                                                  fontWeight:
                                                      StyleWidget.fontWeight),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              divider(),
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
                                              color: FuAppTheme.isDarkMode
                                                  ? StyleWidget.white
                                                  : StyleWidget.costmary,
                                              fontWeight: FontWeight.w600),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ''.decodeDate(
                                                  repliesDate(data.date, 0), 0),
                                              //enter,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color:
                                                      FuAppTheme.isDarkMode ==
                                                              false
                                                          ? StyleWidget.black
                                                          : StyleWidget.white,
                                                  fontWeight:
                                                      StyleWidget.fontWeight),
                                            ),
                                          ],
                                        ),
                                      )),
                                  8.width,
                                  Icon(
                                    MdiIcons.earth,
                                    size: MySize.size20,
                                    color: FuAppTheme.isDarkMode == false
                                        ? themeData.colorScheme.primary
                                        : StyleWidget.white.withAlpha(150),
                                  ),
                                ],
                              ),
                              divider(),
                              data.note.toString().isNotEmpty
                                  ? Row(
                                      children: [
                                        Flexible(
                                            flex: 2,
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'التهمة: ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: FuAppTheme
                                                                .isDarkMode ==
                                                            false
                                                        ? StyleWidget.costmary
                                                        : StyleWidget.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: data.note.toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: FuAppTheme
                                                                    .isDarkMode ==
                                                                false
                                                            ? StyleWidget.black
                                                            : StyleWidget.white,
                                                        fontWeight: StyleWidget
                                                            .fontWeight),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    )
                                  : const SizedBox(),
                              data.note.toString().isNotEmpty
                                  ? divider()
                                  : const SizedBox(),
                              // This is the first alarm
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      flex: 2,
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'التنبية الاول: ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color:
                                                  FuAppTheme.isDarkMode == false
                                                      ? StyleWidget.costmary
                                                      : StyleWidget.white,
                                              fontWeight: FontWeight.w600),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ''.decodeDate(
                                                  repliesDate(data.date, 168),
                                                  0),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color:
                                                      FuAppTheme.isDarkMode ==
                                                              false
                                                          ? StyleWidget.black
                                                          : StyleWidget.white,
                                                  fontWeight:
                                                      StyleWidget.fontWeight),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'يتبقى: ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color:
                                                  FuAppTheme.isDarkMode == false
                                                      ? StyleWidget.costmary
                                                      : StyleWidget.white,
                                              fontWeight: FontWeight.w600),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ''.replaceFarsiNumber(''
                                                          .remainingDays(
                                                              data.date, 144)
                                                          .toString()
                                                          .split('|')[1]
                                                          .toString() !=
                                                      '0'
                                                  ? ''
                                                          .remainingDays(
                                                              data.date, 144)
                                                          .toString()
                                                          .toString()
                                                          .split('|')[0]
                                                          .toString() +
                                                      ''
                                                          .remainingDays(
                                                              data.date, 144)
                                                          .toString()
                                                          .toString()
                                                          .split('|')[1]
                                                          .toString()
                                                  : ''
                                                      .remainingDays(
                                                          data.date, 144)
                                                      .toString()
                                                      .toString()
                                                      .split('|')[0]
                                                      .toString()),
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: FuAppTheme.isDarkMode ==
                                                        false
                                                    ? StyleWidget.black
                                                    : StyleWidget.white,
                                                fontWeight:
                                                    StyleWidget.fontWeight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  8.width,
                                  Container(
                                    height: 8,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color:
                                          HexColor('#87A0E5').withOpacity(0.2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                    child: Wrap(
                                      children: <Widget>[
                                        Container(
                                          width: (''
                                                      .remainingDays(
                                                          data.date, 144)
                                                      .toString()
                                                      .toString()
                                                      .split('|')[0]
                                                      .toDouble() -
                                                  6.0) /
                                              6.0 *
                                              70.0.abs() *
                                              -1,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              HexColor('#87A0E5'),
                                              HexColor('#87A0E5')
                                                  .withOpacity(0.5),
                                            ]),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ).paddingTop(4),
                                ],
                              ),
                              divider(),

                              // This is the second alarm
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'التنبية الثاني: ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color:
                                                  FuAppTheme.isDarkMode == false
                                                      ? StyleWidget.costmary
                                                      : StyleWidget.white,
                                              fontWeight: FontWeight.w600),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ''.decodeDate(
                                                  repliesDate(data.date, 1224),
                                                  0),
                                              // first45,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: FuAppTheme.isDarkMode ==
                                                        false
                                                    ? StyleWidget.black
                                                    : StyleWidget.white,
                                                fontWeight:
                                                    StyleWidget.fontWeight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'يتبقى: ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color:
                                                  FuAppTheme.isDarkMode == false
                                                      ? StyleWidget.costmary
                                                      : StyleWidget.white,
                                              fontWeight: FontWeight.w600),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ''.replaceFarsiNumber(''
                                                          .remainingDays(
                                                              data.date, 1224)
                                                          .toString()
                                                          .split('|')[1]
                                                          .toString() !=
                                                      '0'
                                                  ? ''
                                                          .remainingDays(
                                                              data.date, 1224)
                                                          .toString()
                                                          .split('|')[0]
                                                          .toString() +
                                                      ''
                                                          .remainingDays(
                                                              data.date, 1224)
                                                          .toString()
                                                          .split('|')[1]
                                                          .toString()
                                                  : ''
                                                      .remainingDays(
                                                          data.date, 1224)
                                                      .toString()
                                                      .split('|')[0]
                                                      .toString()),
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: FuAppTheme.isDarkMode ==
                                                        false
                                                    ? StyleWidget.black
                                                    : StyleWidget.white,
                                                fontWeight:
                                                    StyleWidget.fontWeight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  8.width,
                                  Container(
                                    height: 8,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color:
                                          HexColor('#F56E98').withOpacity(0.2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                    child: Wrap(
                                      children: <Widget>[
                                        Container(
                                          width: (''
                                                      .remainingDays(
                                                          data.date, 1224)
                                                      .toString()
                                                      .split('|')[0]
                                                      .toDouble() -
                                                  51.0) /
                                              51.0 *
                                              70.0.abs() *
                                              -1,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              HexColor('#F56E98')
                                                  .withOpacity(0.7),
                                              HexColor('#F56E98'),
                                            ]),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).paddingTop(4),
                                ],
                              ),
                              divider(),
                              // This is the third alarm

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'التنبية الثالث: ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color:
                                                  FuAppTheme.isDarkMode == false
                                                      ? StyleWidget.costmary
                                                      : StyleWidget.white,
                                              fontWeight: FontWeight.w600),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ''.decodeDate(
                                                  repliesDate(data.date, 2304),
                                                  0),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color:
                                                      FuAppTheme.isDarkMode ==
                                                              false
                                                          ? StyleWidget.black
                                                          : StyleWidget.white,
                                                  fontWeight:
                                                      StyleWidget.fontWeight),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'يتبقى: ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color:
                                                  FuAppTheme.isDarkMode == false
                                                      ? StyleWidget.costmary
                                                      : StyleWidget.white,
                                              fontWeight: FontWeight.w600),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ''.replaceFarsiNumber(''
                                                          .remainingDays(
                                                              data.date, 2304)
                                                          .toString()
                                                          .split('|')[1]
                                                          .toString() !=
                                                      '0'
                                                  ? ''
                                                          .remainingDays(
                                                              data.date, 2304)
                                                          .toString()
                                                          .split('|')[0]
                                                          .toString() +
                                                      ''
                                                          .remainingDays(
                                                              data.date, 2304)
                                                          .toString()
                                                          .toString()
                                                          .split('|')[1]
                                                          .toString()
                                                  : ''
                                                      .remainingDays(
                                                          data.date, 2304)
                                                      .toString()
                                                      .toString()
                                                      .split('|')[0]
                                                      .toString()),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color:
                                                      FuAppTheme.isDarkMode ==
                                                              false
                                                          ? StyleWidget.black
                                                          : StyleWidget.white,
                                                  fontWeight:
                                                      StyleWidget.fontWeight),
                                            ),
                                          ],
                                        ),
                                      )),
                                  8.width,
                                  Container(
                                    height: 8,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color:
                                          HexColor('#F1B440').withOpacity(0.2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                    child: Wrap(
                                      children: <Widget>[
                                        Container(
                                          width: (''
                                                      .remainingDays(
                                                          data.date, 2304)
                                                      .toString()
                                                      .split('|')[0]
                                                      .toDouble() -
                                                  96.0) /
                                              96.0 *
                                              70.0.abs() *
                                              -1,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              HexColor('#F1B440')
                                                  .withOpacity(0.7),
                                              HexColor('#F1B440'),
                                            ]),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).paddingTop(4),
                                ],
                              ),

                              5.height,
                              divider(),

                              // This is note
                              data.note.toString().isNotEmpty
                                  ? Row(children: [
                                      Flexible(
                                          flex: 1,
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'الملاحظة: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: StyleWidget.costmary,
                                                  fontWeight: FontWeight.w600),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: data.note.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )),
                                      4.width,
                                    ])
                                  : const SizedBox()
                            ],
                          ).paddingAll(8)
                        ],
                      );
                    });
              }),
        ));
  }

  rowDoubleText(data, text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 2,
            child: RichText(
              text: TextSpan(
                text: text,
                style: TextStyle(
                    fontSize: 18,
                    color: StyleWidget.costmary,
                    fontWeight: FontWeight.w600),
                children: <TextSpan>[
                  TextSpan(
                    text: data,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: StyleWidget.fontWeight),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
