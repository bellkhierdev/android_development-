//version 1.0.0+1

import 'package:flutter/material.dart';
import 'package:issue/export.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

enum FilterByTime { thisDay, thisWeek, thisMonth, thisYear, all }

//Class Filter Bottom Sheet
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  bool colorBlack = false,
      colorRed = true,
      colorOrange = false,
      colorTeal = true,
      colorPurple = false;

  int? getIndex;
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
            color: FuAppTheme.isDarkMode == false
                ? Colors.white
                : FuAppTheme.theme.cardColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        padding: FuSpacing.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  GestureDetector(
                      onTap: () async {
                        context
                            .read<FilterProvider>()
                            .manageNumberIssue(id: '', numberIssue: '');
                        if (getIndex == 0) {
                          await context
                              .read<FilterProvider>()
                              .getDefaultFilterByTime(FilterByTime.thisDay);
                          Navigator.pop(context);
                        } else if (getIndex == 1) {
                          await context
                              .read<FilterProvider>()
                              .getDefaultFilterByTime(FilterByTime.thisWeek);
                          Navigator.pop(context);
                        } else if (getIndex == 2) {
                          await context
                              .read<FilterProvider>()
                              .getDefaultFilterByTime(FilterByTime.thisMonth);
                          Navigator.pop(context);
                        } else if (getIndex == 3) {
                          await context
                              .read<FilterProvider>()
                              .getDefaultFilterByTime(FilterByTime.thisYear);
                          Navigator.pop(context);
                        } else {
                          await context
                              .read<FilterProvider>()
                              .getDefaultFilterByTime(FilterByTime.all);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                          padding: FuSpacing.all(8),
                          decoration: BoxDecoration(
                              color: FuAppTheme.theme.colorScheme.primary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(22))),
                          child: Icon(
                            MdiIcons.check,
                            size: 20,
                            color: FuAppTheme.theme.colorScheme.onPrimary,
                          )))
                ],
              ),
              FuSpacing.height(8),
              const FuText(
                "ترتب حسب : ",
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: Spacing.only(top: 8, bottom: 8),
                padding: Spacing.vertical(0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: Spacing.left(0),
                        child: singleCategory(title: "الكل", index: 4),
                      ),
                      singleCategory(title: "اليوم", index: 0),
                      singleCategory(title: "الاسبوع", index: 1),
                      singleCategory(title: "الشهر", index: 2),
                      singleCategory(title: "العام", index: 3),
                    ],
                  ),
                ),
              ),
              FuSpacing.height(16),
              const FuText(
                "رقم القضية",
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FuSpacing.height(16),
              SizedBox(
                  height: 50,
                  width: context.width,
                  child: SnapHelperWidget<List<Accused>?>(
                      future: FilterProvider().getAccuse(context),
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
                            itemCount: myData.length,
                            shrinkWrap: false,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: ((BuildContext context, index) {
                              var data = myData[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Consumer<FilterProvider>(
                                    builder: (context, watch, child) =>
                                        GestureDetector(
                                      onTap: () async {
                                        if (watch.idNumberIssueValue ==
                                            data.id.toString()) {
                                          //This is for when user  again press to button doing ignore old the same issue number
                                          watch.manageNumberIssue(
                                              id: '', numberIssue: '');
                                          Navigator.pop(context);
                                        } else {
                                          watch.manageNumberIssue(
                                              id: data.id.toString(),
                                              numberIssue: data.issueNumber);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: SelectNumberIssue(
                                        numberIssue:
                                            data.issueNumber.toString(),
                                        id: data.id.toString(),
                                      ),
                                    ).paddingSymmetric(horizontal: 6),
                                  ),
                                ],
                              );
                            }));
                      }))
            ],
          ),
        ),
      ),
    );
  }

  Widget singleCategory({required String title, int? index}) {
    var selected = context.read<FilterProvider>().selectedDate;
    bool isSelected = (selected == index);

    return InkWell(
        onTap: () {
          if (!isSelected) {
            setState(() {
              getIndex = index;
              context.read<FilterProvider>().changeSelectedDate(index);
            });
          }
        },
        child: Container(
          margin: Spacing.fromLTRB(12, 8, 0, 8),
          decoration: BoxDecoration(
              color: isSelected
                  ? themeData.colorScheme.primary
                  : FuAppTheme.customTheme.bgLayer1,
              border: Border.all(
                  color: FuAppTheme.customTheme.bgLayer1,
                  width: isSelected ? 0 : 0.8),
              borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                          color: themeData.colorScheme.primary.withAlpha(80),
                          blurRadius: MySize.size6!,
                          spreadRadius: 1,
                          offset: Offset(0, MySize.size2))
                    ]
                  : []),
          padding: Spacing.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: Spacing.left(8),
                child: Text(
                  title,
                  style: FuTextStyle.getStyle(
                      textStyle: themeData.textTheme.bodyText2,
                      color: isSelected
                          ? themeData.colorScheme.onPrimary
                          : themeData.colorScheme.onBackground),
                ),
              )
            ],
          ),
        ));
  }

  Widget colorWidget({Color? color, bool checked = true}) {
    return FuContainer.none(
      width: 36,
      height: 36,
      color: color,
      borderRadiusAll: 18,
      child: checked
          ? const Center(
              child: Icon(
                MdiIcons.check,
                color: Colors.white,
                size: 20,
              ),
            )
          : Container(),
    );
  }
}

//Single Size Widget
class SelectNumberIssue extends StatelessWidget {
  final String numberIssue;
  final String id;
  const SelectNumberIssue(
      {Key? key, required this.numberIssue, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, _) => FuCard(
        width: 70,
        height: 44,
        paddingAll: 0,
        bordered: filterProvider.idNumberIssueValue == id ? false : true,
        border: Border.all(color: FuAppTheme.customTheme.border2, width: 1.6),
        color: filterProvider.idNumberIssueValue == id
            ? themeData.colorScheme.primary
            : Colors.transparent,
        child: Center(
          child: FuText(
            numberIssue.toString(),
            letterSpacing: -0.2,
            fontWeight: 700,
            overflow: TextOverflow.ellipsis,
            color: filterProvider.idNumberIssueValue == id
                ? themeData.colorScheme.onPrimary
                : themeData.colorScheme.onBackground,
          ),
        ),
      ),
    );
    // .onTap((){
    //   //  Navigator.pop(context);
    // });
  }
}

//Sort Bottom Sheet
class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet({Key? key}) : super(key: key);

  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(
      builder: (context, provider, child) {
        return Container(
          color: FuAppTheme.isDarkMode == false
              ? StyleWidget.white
              : FuAppTheme.theme.cardColor,
          child: Container(
            padding: FuSpacing.xy(24, 16),
            decoration: BoxDecoration(
                color: FuAppTheme.isDarkMode == false
                    ? Colors.transparent
                    : FuAppTheme.theme.cardColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        provider.manageRadioValue;
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: <Widget>[
                          Radio(
                            onChanged: (dynamic value) {
                              provider.manageRadioValue(value);
                              Navigator.pop(context);
                            },
                            groupValue: provider.radioValue ?? 0,
                            value: 0,
                            visualDensity: VisualDensity.compact,
                            activeColor: FuAppTheme.theme.colorScheme.primary,
                          ),
                          const FuText.sh2(
                            " (أ/ي)تصاعدي ",
                            fontSize: 18,
                            textStyle: TextStyle(
                              color: StyleWidget.nearlyBlack,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FuSpacing.height(8),
                    Row(
                      children: <Widget>[
                        Radio(
                          onChanged: (dynamic value) {
                            provider.manageRadioValue(value);
                            Navigator.pop(context);
                          },
                          groupValue: provider.radioValue,
                          value: 1,
                          visualDensity: VisualDensity.compact,
                          activeColor: FuAppTheme.theme.colorScheme.primary,
                        ),
                        const FuText.sh2(
                          "المظاف مؤخراً",
                          fontSize: 18,
                          textStyle: TextStyle(
                            color: StyleWidget.nearlyBlack,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    FuSpacing.height(8),
                    Row(
                      children: <Widget>[
                        Radio(
                          onChanged: (dynamic value) {
                            provider.manageRadioValue(value);
                            Navigator.pop(context);
                          },
                          groupValue: provider.radioValue,
                          value: 3,
                          visualDensity: VisualDensity.compact,
                          activeColor: FuAppTheme.theme.colorScheme.primary,
                        ),
                        const FuText.sh2(
                          "منتهي",
                          fontSize: 18,
                          textStyle: TextStyle(
                            color: StyleWidget.nearlyBlack,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    FuSpacing.height(8),
                    Row(
                      children: <Widget>[
                        Radio(
                          onChanged: (dynamic value) {
                            provider.manageRadioValue(value);
                            Navigator.pop(context);
                          },
                          groupValue: provider.radioValue,
                          value: 2,
                          visualDensity: VisualDensity.compact,
                          activeColor: FuAppTheme.theme.colorScheme.primary,
                        ),
                        const FuText.sh2(
                          "على وشك الانتهاء  ",
                          fontSize: 18,
                          textStyle: TextStyle(
                            color: StyleWidget.nearlyBlack,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
