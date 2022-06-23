//version 1.0.0+1

import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:issue/export.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'filter_body.dart';

enum check { isEmpty, isNotEmpty }

// ignore: must_be_immutable
class FilterHomeScreen extends StatefulWidget {
  const FilterHomeScreen({Key? key}) : super(key: key);

  @override
  _FilterHomeScreenState createState() => _FilterHomeScreenState();
}

class _FilterHomeScreenState extends State<FilterHomeScreen>
    with SingleTickerProviderStateMixin {
  double findAspectRatio(double width) {
    //Logic for aspect ratio of grid view
    return (width / 2 - 24) / ((width / 2 - 24) + 64);
  }

  List<Accused>? mySnapshot;

  String query = '';

  late ThemeData themeData;
  int? selectedCategory = 0;
  @override
  void initState() {
    super.initState();
    //------------IF DELETE THIS FUNCTION MAYBE DOING ERROR IN THE APPLICATION------------//

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await Jiffy.locale(
          "en"); //this is for translation date to language english
      //this is for if not equal everything's do this
      //this doing return default data stor
      context.read<FilterProvider>().manageRadioValue(4);
      //this is for get default filter
      context.read<FilterProvider>().getDefaultFilterByTime(FilterByTime.all);

      context.read<FilterProvider>().changeSelectedDate(5);

      //when open the filter screen this get manageNumberIssue value equal null or ''

      context.read<FilterProvider>().manageNumberIssue(id: '', numberIssue: '');
    });
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var _toDay = now.subtract(const Duration(hours: 24));
    var _thisWeek = now.subtract(const Duration(days: 7));
    var _thisMonth = DateTime(now.year, now.month - 1, now.day);
    var _thisYear = DateTime(now.year - 1, now.month, now.day);
    themeData = Theme.of(context); //this is for initialize ThemeData
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:
            FuAppTheme.isDarkMode ? Colors.black.withAlpha(60) : Colors.white,
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                //Search
                InkWell(
                    highlightColor: Colors.transparent,
                    onTap: () => showSearch(
                          context: context,
                          delegate: SearchBarDelegate(),
                        ),
                    child: Container(
                      margin: Spacing.all(5),
                      padding: FuSpacing.all(9),
                      decoration: BoxDecoration(
                          color: FuAppTheme.isDarkMode
                              ? FuAppTheme.theme.scaffoldBackgroundColor
                              : StyleWidget.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: FuAppTheme.customTheme.border2, width: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            MdiIcons.magnify,
                            color: FuAppTheme.theme.colorScheme.primary,
                            size: 20,
                          ),
                          Container(
                              margin: FuSpacing.left(8),
                              child: Text(
                                "بحث",
                                style: titleStyle,
                              ))
                        ],
                      ),
                    )).expand(),
                FuSpacing.width(8),
                //order
                InkWell(
                    highlightColor: Colors.transparent,
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext buildContext) {
                            return const SortBottomSheet();
                          });
                    },
                    child: Container(
                      margin: Spacing.all(5),
                      padding: FuSpacing.all(9),
                      decoration: BoxDecoration(
                          color: FuAppTheme.isDarkMode == false
                              ? StyleWidget.white
                              : FuAppTheme.theme.scaffoldBackgroundColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: FuAppTheme.customTheme.border2, width: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            MdiIcons.swapVertical,
                            color: FuAppTheme.theme.colorScheme.primary,
                            size: 20,
                          ),
                          FuSpacing.width(8),
                          Text(
                            "ترتيب",
                            style: titleStyle,
                          )
                        ],
                      ),
                    )).expand(),
                FuSpacing.width(8),
                //filter
                InkWell(
                    highlightColor: Colors.transparent,
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext buildContext) {
                            return const FilterBottomSheet();
                          });
                    },
                    child: Container(
                      margin: Spacing.all(5),
                      padding: FuSpacing.all(9),
                      decoration: BoxDecoration(
                          color: FuAppTheme.isDarkMode == false
                              ? Colors.white
                              : FuAppTheme.theme.scaffoldBackgroundColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: FuAppTheme.customTheme.border2, width: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            MdiIcons.tune,
                            color: FuAppTheme.theme.colorScheme.primary,
                            size: 22,
                          ),
                          FuSpacing.width(8),
                          Text(
                            "فلتر",
                            style: titleStyle,
                          )
                        ],
                      ),
                    )).expand(),
              ],
            ).paddingOnly(
                left: 12,
                right: 12,
                top: FuAppTheme.isDarkMode == true ? 3 : 0),

            Divider(
              height: 5.0,
              thickness: 0.5,
              color: FuAppTheme.isDarkMode == false
                  ? Colors.black.withAlpha(50)
                  : Colors.grey.withAlpha(150),
            ),
            //get data
            FutureBuilder<List<Accused>>(
                future: StateAccused().searchDate(query),
                builder: (context, AsyncSnapshot<List<Accused>> snapshot) {
                  //on Error
                  if (snapshot.error != null) {
                    //   print(snapshot.error);
                    return ErrorResponse.awesomeDialog(
                      error: snapshot.error.toString(),
                      context: context,
                      dialogType: DialogType.ERROR,
                    );
                  }
                  //on Data equal null
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                      FuAppTheme.theme.colorScheme.primary,
                    )));
                  } else if (snapshot.data!.isEmpty) {
                    return const NotFoundData(
                      error: '! ...لا توجد بيانات',
                    ).expand();
                  } else {
                    check defaultLoading = check.isNotEmpty;
                    return SnapHelperWidget<List<Accused>?>(
                        future: FilterProvider().getAccuse(context),
                        onSuccess: (List<Accused>? myData) {
                          if (myData!.isEmpty) {
                            return const NotFoundData(
                              error: '! ...لا توجد بيانات',
                            ).expand();
                          }
                          var watchResult = context
                              .watch<FilterProvider>()
                              .defaultFilterByTime;
                          if (watchResult.toString().isEmpty) {
                            return const NotFoundData(
                              error: '! ...لا توجد بيانات',
                            ).expand();
                          }
                          //This is for check FilterBy number Issue
                          var checkByNumberIssue = context
                              .read<FilterProvider>()
                              .numberIssue
                              .toString();
                          if (checkByNumberIssue.isNotEmpty) {
                            List<Accused>? result = myData
                                .where((book) =>
                                    book.issueNumber.toString() ==
                                    checkByNumberIssue)
                                .toList();

                            myData = result;
                          }

                          if (watchResult == FilterByTime.all) {
                            // you can do hire everything's
                          } else {
                            sortDataByDate(
                              DateTime value,
                              List<Accused>? data,
                            ) {
                              List<Accused>? result = myData?.where((element) {
                                final date = element.date;
                                return value
                                    .isBefore(DateTime.parse(date.toString()));
                              }).toList();
                              if (result!.isNotEmpty) {
                                myData = result;
                              } else {
                                defaultLoading = check.isEmpty;
                              }
                            }

                            //this is for check FilterByTime is [thisDay or thisWeek or thisMonth or thisYear]

                            void checkFilterByDate( BuildContext context, List<Accused>? data,
                            {FilterByTime? filterByTime}) async {
                              filterByTime ??= watchResult;
                              switch (filterByTime) {
                                case FilterByTime.thisDay:
                                  return sortDataByDate(_toDay, data);
                                case FilterByTime.thisWeek:
                                  return sortDataByDate(_thisWeek, data);
                                case FilterByTime.thisMonth:
                                  return sortDataByDate(_thisMonth, data);
                                case FilterByTime.thisYear:
                                  return sortDataByDate(_thisYear, data);
                                default:
                                  return;
                              }
                            }

                            checkFilterByDate(
                              context,
                              myData,
                            );
                          }
                          if (defaultLoading == check.isEmpty) {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    ImagesUrl.notFound,
                                  ),
                                  Text(
                                    'لا يوجد بيانات بحسب هذا التاريخ',
                                    style: TextStyle(
                                        color: FuAppTheme.theme.primaryColor,
                                        fontSize: 20,
                                        fontFamily: 'Cairo'),
                                  ),
                                ]).expand();
                          }

                          return Consumer<FilterProvider>(
                              builder: (context, provider, child) {
                            return ListView.builder(
                              padding: const EdgeInsets.all(0.0),
                              itemCount: myData?.length,
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              itemBuilder: (BuildContext context, int index) {

                             //----if value equal 0 return name Ascending order (default result)----//
                                if (provider.radioValue == 0) {
                                  myData?.sort((a, b) {
                                    return a.name!
                                        .compareTo(b.name!.toLowerCase());
                                  });
                                }

                                //---- if value equal 1 return date Descending Order ----//
                                if (provider.radioValue == 1) {
                                  myData?.sort((a, b) {
                                    return b.date!
                                        .compareTo(a.date!.toLowerCase());
                                  });
                                }

                                if (provider.radioValue == 3) {
                                  myData?.sort((a, b) {
                                    return b.isCompleted.toString().compareTo(
                                        a.isCompleted.toString().toLowerCase());
                                  });
                                } else {}
                                mySnapshot = myData!;
                                var data = myData![index];

                                return GestureDetector(
                                    onTap: () {
                                      data.isCompleted == 1
                                          ?  ErrorResponse.showToastWidget(error:'لقد تم انتهاء التهمة',colorShowToast: Colors.red)
                                          : navigateAccusedDetailsScreen(data);
                                    },
                                    child: FilterBody(
                                      data: data,
                                      themeData: themeData,
                                    ));
                             
                              },
                            ).expand();
                          });
                        });
                  }
                })
          ],
        ),
      ),
    );
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  void navigateAccusedDetailsScreen(data) {
    Route route = CostumeTransition(HealthActivityScreen(
      accused: data,
    ));
    Navigator.push(context, route).then(onGoBack);
  }
}
