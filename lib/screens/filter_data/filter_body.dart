// //version 1.0.0+1


import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../export.dart';

class FilterBody extends StatelessWidget {
  final Accused data;
  final ThemeData themeData;
  const FilterBody({Key? key, required this.data, required this.themeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Border border =
        Border.all(color: themeData.primaryColor.withAlpha(120), width: 1);

    String typeAlarm = data.nextAlarm == 1 && data.thirdAlert == 0
        ? 'الثالث'
        : data.thirdAlert == 1 && data.nextAlarm == 1
            ? 'الثالث'
            : data.firstAlarm == 1 && data.nextAlarm == 0
                ? 'الثاني'
                : 'الأول';

    String typeAlarm1 =
        data.nextAlarm == 1 && data.thirdAlert == 0 && data.firstAlarm == 1
            ? 'الثاني'
            : data.thirdAlert == 1
                ? 'الثالث'
                : 'الأول';
    /* this is enter Issue */
    String enter = ''.decodeDate(''.repliesDate1(data.date, 0), 1);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding:
              EdgeInsets.only(left: 2.w, right: 2.w, bottom: 0.1.h, top: 0.1.h),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: FuAppTheme.isDarkMode
                ? themeData.scaffoldBackgroundColor
                : Colors.white,
            shadowColor: FuAppTheme.isDarkMode
                ? HexColor('#8A98E8').withAlpha(1)
                : HexColor('#8A98E8'),
            elevation: 5.0,
            child: FuContainer.bordered(
              color: FuAppTheme.isDarkMode
                  ? themeData.scaffoldBackgroundColor
                  : Colors.white,
              padding: const EdgeInsets.all(1),
              borderRadiusAll: 5,
              border: Border.all(
                  color: themeData.textTheme.bodyText1!.color!, width: 0.2),
              borderRadius: const BorderRadius.all( Radius.circular(10)),
              child: Stack(
                overflow: Overflow.visible,
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 2,
                              child: Text(
                                data.name.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: FuAppTheme
                                      .theme.textTheme.bodyText1!.color,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ).paddingRight(10)),
                        ],
                      ),
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
                                      text: enter
                                          .toString()
                                          .split(', ۷ ص')[0]
                                          .toString(),
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
                          Icon(MdiIcons.earth,
                              size: MySize.size20,
                              color: FuAppTheme.isDarkMode
                                  ? StyleWidget.white.withAlpha(150)
                                  : StyleWidget.black.withAlpha(120)),
                        ],
                      ).paddingRight(10),
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
                                        data.issueNumber.toString(),
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
                          data.isCompleted == 1
                              ? Padding(
                                  padding: Spacing.only(left: 15, bottom: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        child: FuContainer.bordered(
                                          // margin: Spacing.all(spacing),
                                          border: border,
                                          padding:
                                              Spacing.only(left: 9, right: 9),
                                          child: const Text('إعادة تفعيل'),
                                        ),
                                        onTap: () {
                                          ErrorResponse.awesomeDialog(
                                            error:
                                                "هل تريد إعادة تفعيل هذا المتهم",
                                            context: context,
                                            color: Colors.blue,
                                            dialogType: DialogType.INFO,
                                            btnCancel: 'الغاء',
                                            btnOkOnPress: () async {
                                              return await context
                                                  .read<FilterProvider>()
                                                  .enableAccuseNotification(
                                                      id: data.id!,
                                                      date: DateTime.now()
                                                          .toString());
                                            },
                                            btnCancelOnPress: () {},
                                          );
                                        },
                                      ),
                                    ],
                                  ))
                              : data.firstAlarm == 1
                                  ? Padding(
                                      padding:
                                          Spacing.only(left: 2.w, bottom: 5),
                                      child: FuContainer.bordered(
                                        border: border,
                                        padding:
                                            Spacing.only(left: 5, right: 5),
                                        child: Text(
                                            'تم إنهاء التنبية $typeAlarm1'),
                                      ),
                                    )
                                  : const SizedBox()
                        ],
                      ).paddingRight(10)
                    ],
                  ),
                  Positioned(
                      left: 5,
                      top: 2,
                      child: FuContainer.roundBordered(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(left: 0, top: 0),
                        color: data.isCompleted == 1
                            ? const Color.fromARGB(255, 248, 108, 190)
                            : const Color(0xFF475CEA),
                        child: FuText(
                            data.isCompleted == 1
                                ? 'منتهي'
                                : typeAlarm.toString(),
                            color: Colors.white),
                      ))
                ],
              ),
            ),
          ).paddingOnly(left: 10, right: 10).paddingTop(15),
        ));
  }
}
