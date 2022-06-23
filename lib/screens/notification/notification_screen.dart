//version 1.0.0+1

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:issue/export.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../data/models/notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationDialogState createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationScreen> {
  late ThemeData themeData;

  String alarm = '';
  String typeAlarm = '';

  Color darkHeaderClr = const Color(0xFF424242);
  @override
  void initState() {
    super.initState();
    deleteCountNotification();
  }

  void deleteCountNotification() async {
    context.read<HomeScreenProvider>().deleteCountNotification();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          backgroundColor: FuAppTheme.isDarkMode == false
              ? Colors.white
              : themeData.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: FuAppTheme.isDarkMode == false
                ? Colors.white
                : themeData.scaffoldBackgroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const FuText.h5(
              "الاشعارات",
              fontWeight: 600,
            ),
            actions: <Widget>[
              Container(
                margin: Spacing.right(16),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: FuAppTheme.theme.colorScheme.onBackground,
                  ),
                ),
              )
            ],
          ),
          body: SnapHelperWidget<List<NotificationModel>?>(
              future: FilterDataForNotification().filterData(
                  isWhenAppIsTerminated: false, loadForNotificationPage: true),
              loadingWidget: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: CircularProgressIndicator(
                      color: context.theme.primaryColor),
                ),
              ),
              errorWidget: Padding(
                padding: const EdgeInsets.all(100.0),
                child: const NotFoundData(
                  error: 'هناك خطاءً ما',
                ).center(),
              ),
              onSuccess: (List<NotificationModel>? myData) {
                if (myData!.isEmpty) {
                  return Center(
                    child: const NotFoundData(
                      error: '! ...لا توجد إشعارات',
                    ).paddingTop(10.h),
                  );
                }

                return ListView.builder(
                    itemCount: myData.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = myData[index];

                      return bodyNotificationScreen(
                        data,
                      );
                    });
              })),
    );
  }

  Widget bodyNotificationScreen(
    NotificationModel data,
  ) {
    String firstAlarm = FilterDataForNotification().getDifferenceDateByDays(
        date: data.dateTime.toString(),
        differenceHours: data.typeAlarm.toString() == 'الاول'
            ? 144
            : data.typeAlarm.toString() == 'الثاني'
                ? 1224
                : data.typeAlarm.toString() == 'الثالث'
                    ? 1224
                    : 0);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
          color: FuAppTheme.isDarkMode
              ? Colors.black.withAlpha(60)
              : const Color(0xFFE4F3FF),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FuContainer.rounded(
                    width: 52,
                    height: 52,
                    padding: Spacing.all(1),
                    color: FuAppTheme.theme.colorScheme.primary.withAlpha(40),
                    child: Center(
                        child: Text(
                      data.typeAlarm.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: FuAppTheme.theme.colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    )),
                  ).paddingLeft(20),
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: RichText(
                        overflow: TextOverflow.visible,
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                          text: data.name.toString(),
                          style: TextStyle(
                              fontSize: 17,
                              color: FuAppTheme.isDarkMode
                                  ? StyleWidget.white
                                  : StyleWidget.costmary,
                              overflow: TextOverflow.visible,
                              fontWeight: FontWeight.w600),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' سينتهي'
                                      ' التنبية  ${data.typeAlarm} له ' +
                                  (firstAlarm == '0' ? 'اليوم ' : 'غداً ') +
                                  'الساعة ' +
                                  ''.myReplaceFarsiNumber(
                                    Jiffy(data.dateTime == null ||
                                                data.dateTime.toString().isEmpty
                                            ? DateTime.now()
                                            : data.dateTime.toString())
                                        .jm,
                                  ),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: FuAppTheme.isDarkMode
                                      ? StyleWidget.white
                                      : Colors.black,
                                  overflow: TextOverflow.visible,
                                  fontWeight: StyleWidget.fontWeight),
                            ),
                      
                          ],
                        ),
                      ).expand()),
                  Icon(Icons.keyboard_control,
                          color: FuAppTheme.isDarkMode
                              ? const Color(0xFFE4F3FF)
                              : Colors.black)
                      .paddingLeft(12),
                ],
              ).paddingOnly(left: 10, right: 10).paddingTop(18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '. منذ ' + ''.myReplaceFarsiNumber(

                        // Jiffy(data.sentTime.toString()).jm,),
                        differenceDays(data.sentTime.toString(), 0).toString()),
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: FuAppTheme.isDarkMode
                            ? StyleWidget.white
                            : StyleWidget.dark_grey,
                        // : themeData.primaryColor,
                        overflow: TextOverflow.visible,
                        fontWeight: StyleWidget.fontWeight),
                  ),
                ],
              ).paddingOnly(
                right: 21.w,
              ),
            ],
          )).paddingAll(5),
    );
  }

  /// this is for Remaining days until the end of the alert
  differenceDays(
    date,
    alarm,
  ) {
    String? result;

    ///This is to compare the (week or first 45 day or next 45 day) after the date of his entry to the date of his entry,
    ///and to obtain the remaining days for a (week or first 45 day or next 45 day) after his entry
    final dateAftreWeek =
        DateTime.parse(date!.toString()).add(const Duration(hours: 0));
    DateTime dates = DateTime.now();

    final diffDy = dates.difference(dateAftreWeek).inDays;
    final diffHr = dates.difference(dateAftreWeek).inHours;
    final diffMi1 = dates.difference(dateAftreWeek).inMinutes;
   
    // if (diffDy.toString().startsWith('-')) {
    if (diffMi1 != 0 && diffMi1 <= 60) {
      return result = ' ${diffMi1.toString().toString()} دقيقة';
    } else if (diffDy == 0 && diffDy <= 24) {
      if (diffHr != 0) {
        return result = '${diffHr.toString().toString()}ساعة';
      } else if (diffDy != 0) {
        return result = '${diffDy.toString()}يوم';
      } else {
        return result = 'الان';
      }
    }
    // } else {
    //   return result = ' الان ';
    // }
  }
}
