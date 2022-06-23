//version 1.0.0+1

import 'package:flutter/material.dart';
import 'package:issue/export.dart';
import 'package:issue/widgets/size.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBarDelegate extends SearchDelegate<Accused?> {
  late List<String> searchHistory;
  SharedPreferences? prefs;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: FuAppTheme.theme.textTheme.bodyText1!.color,
        ),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  String? searchFieldLabel = 'بحث';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final _lightTheme = theme.copyWith(
        inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.grey)),
        primaryColor: Colors.white,
        primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        primaryTextTheme: theme.textTheme,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white);
    final _darkTheme = theme.copyWith(
      scaffoldBackgroundColor: FuAppTheme.theme.scaffoldBackgroundColor,
      inputDecorationTheme:
          const InputDecorationTheme(hintStyle: TextStyle(color: Colors.grey)),
      primaryColor: const Color(0xFF303030),
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryTextTheme: theme.textTheme,
    );
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final ThemeData _newtheme =
        FuAppTheme.isDarkMode ? _darkTheme : _lightTheme;
    return _newtheme;
  }

  @override
  TextStyle? searchFieldStyle = TextStyle(
    color: FuAppTheme.theme.textTheme.bodyText1!.color,
  );

  @override
  Widget buildLeading(BuildContext context) {
    return AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation)
        .paddingLeft(10).paddingTop(12)
        .onTap(() {
      close(context, null);
    });
  }

  Future<List<Accused>?> _getData() async {
    final accused = await StateAccused().searchDate(query);
    FuLog(accused.toString());
    return accused;
  }

  Future<List<String>> _getHistory() async {
    prefs ??= await SharedPreferences.getInstance();
    searchHistory = prefs?.getStringList('searchHistory') ?? [];
    return searchHistory;
  }

  @override
  Widget buildResults(BuildContext context) {
    if (prefs != null && query != '') {
      int index = searchHistory.indexOf(query);
      if (index < 0) {
        searchHistory.insert(0, query);
        prefs?.setStringList('searchHistory', searchHistory);
      }
    }
    return FutureBuilder<List<Accused>?>(
      future: _getData(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<List<Accused>?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Center(
              child: NotFoundData(
                error: '! لا توجد بيانات',
              ),
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container(
              margin: EdgeInsets.only(top: Adapt.px(30)),
              alignment: Alignment.topCenter,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.black),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                    color: StyleWidget.primaryClr,
                    fontSize: 30,
                    fontFamily: 'Cairo'),
              );
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: NotFoundData(
                  error: '! لا توجد نتائج ',
                ),
              );
            }

            return _ResultList(
              query: query,
              results: snapshot.data ?? [],
            );
        }
      },
    );
  }

  Widget _buildHistoryList() {
    return FutureBuilder<List<String>>(
      future: _getHistory(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _buildHistoryList();
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container(
              margin: EdgeInsets.only(top: Adapt.px(30)),
              alignment: Alignment.topCenter,
              child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue)),
            );
          case ConnectionState.done:
            if (snapshot.hasError || snapshot.data!.isEmpty) {
              const Center(
                child: NotFoundData(
                  error: '! لا توجد بحوثات مسبقة',
                ),
              );
            }
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                          0,
                          Adapt.px(30),
                          Adapt.px(30),
                          Adapt.px(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              searchHistory.isNotEmpty
                                  ? 'بحثت عليهم مؤخراً'
                                  : '',
                              style: TextStyle(
                                  color: FuAppTheme
                                      .theme.textTheme.bodyText1!.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Adapt.px(35)),
                            ),
                            searchHistory.isNotEmpty
                                ? SizedBox(
                                    height: Adapt.px(40),
                                    child: IconButton(
                                      padding: const EdgeInsets.all(0),
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        if (prefs != null &&
                                            searchHistory.isNotEmpty) {
                                          searchHistory = [];
                                          prefs?.remove('searchHistory');
                                          query = '';
                                          showSuggestions(context);
                                        }
                                      },
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
                      width: Adapt.screenW(),
                      child: Wrap(
                          children: searchHistory.take(10).map((s) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  color: Colors.grey[500],
                                ),
                                5.width,
                                Text(
                                  s.toString(),
                                  style: TextStyle(fontSize: Adapt.px(30)),
                                  overflow: TextOverflow.ellipsis,
                                ).expand(),
                                FuContainer.none(
                                    borderRadius:
                                        BorderRadius.circular(MySize.size6!),
                                    color: FuAppTheme.isDarkMode == false
                                        ? Colors.grey[100]
                                        : FuAppTheme.theme.backgroundColor
                                            .withAlpha(100),
                                    shape: BoxShape.circle,
                                    child: Image(
                                      image: AssetImage(ImagesUrl.profile),
                                      fit: BoxFit.cover,
                                      height: MySize.size56,
                                      width: MySize.size56,
                                    )),
                              ],
                            ).onTap(() {
                              query = s;
                              showResults(context);
                            }),
                            Divider(
                              height: 10.0,
                              thickness: 0.5,
                              color: FuAppTheme.isDarkMode == false
                                  ? Colors.black.withAlpha(50)
                                  : Colors.white.withAlpha(50),
                            ),
                          ],
                        );
                      }).toList()),
                    )
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Adapt.initContext(context);
    return FutureBuilder<List<Accused>?>(
        future: _getData(), // a previously-obtained Future<String> or null
        builder:
            (BuildContext context, AsyncSnapshot<List<Accused>?> snapshot) {
          if (query.isEmpty) {
            return _buildHistoryList();
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _buildHistoryList();
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Container(
                margin: EdgeInsets.only(top: Adapt.px(30)),
                alignment: Alignment.topCenter,
                child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue)),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return _SuggestionList(
                query: query,
                suggestions: snapshot.data ?? [],
                onSelected: (String suggestion) {
                  query = suggestion;
                  showResults(context);
                },
              );
          }
        });
  }
}

Widget _buildSuggestionCell(Accused s, ValueChanged<String> tapped) {
  DateTime dateTime = DateTime.parse(
    s.date.toString(),
  );
  var thisWeek = dateTime.add(const Duration(hours: 144));
  return SizedBox(
      height: Adapt.px(120),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: Colors.grey[500],
              ),
              5.width,
              Text(
                s.name.toString(),
                style: TextStyle(fontSize: Adapt.px(30)),
                overflow: TextOverflow.ellipsis,
              ).expand(),
              Column(
                children: [
                  Text(
                    ''.replaceFarsiNumber(
                        '${''.splitsDate(thisWeek.toString())}'),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontFamily: StyleWidget.fontName,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      color: FuAppTheme.isDarkMode
                          ? StyleWidget.white.withAlpha(150)
                          : StyleWidget.grey.withOpacity(0.5),
                    ),
                  )
                ],
              ),
              FuContainer.none(
                  borderRadius: BorderRadius.circular(MySize.size6!),
                  color: FuAppTheme.isDarkMode
                      ? FuAppTheme.theme.backgroundColor.withAlpha(100)
                      : Colors.grey[100],
                  shape: BoxShape.circle,
                  child: Image(
                    image: AssetImage(ImagesUrl.profile),
                    fit: BoxFit.cover,
                    height: MySize.size56,
                    width: MySize.size56,
                  )),
            ],
          ).onTap(() => tapped(s.name.toString())),
          Divider(
            height: 10.0,
            thickness: 0.5,
            color: FuAppTheme.isDarkMode
                ? Colors.white.withAlpha(50)
                : Colors.black.withAlpha(50),
          ),
        ],
      )).paddingOnly(top: 0, right: 15, left: 15);
 
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList(
      {required this.suggestions,
      required this.query,
      required this.onSelected});

  final List<Accused> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    Adapt.initContext(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final Accused suggestion = suggestions[i];
        return _buildSuggestionCell(suggestion, onSelected);
      },
    );
  }
}

class _ResultList extends StatefulWidget {
  const _ResultList({required this.results, required this.query});

  final List<Accused> results;
  final String query;

  @override
  _ResultListState createState() => _ResultListState();
}

class _ResultListState extends State<_ResultList> {
  late ScrollController scrollController;
  List<Accused>? results;
  String? query;
  late int pageIndex;
  int? totalPage;
  bool? isLoading;

  Future loadData() async {
    bool isBottom = scrollController.position.pixels ==
        scrollController.position.maxScrollExtent;
    if (isBottom && totalPage! > pageIndex) {
      isLoading = true;

      pageIndex++;
      final data = await StateAccused().searchDate(query!);

      if (data.isNotEmpty) {
        pageIndex = data.length;
        totalPage = data.length;
        results?.addAll(data);
      }
      isLoading = false;
    }
  }

  @override
  void initState() {
    results = widget.results;
    query = widget.query;
    pageIndex = 1;
    totalPage = 2;
    isLoading = false;
    scrollController = ScrollController()..addListener(loadData);
      //------------IF DELETE THIS FUNCTION MAYBE DOING ERROR IN THE APPLICATION------------//
       WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await Jiffy.locale("en"); //this is for translation date to language english
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     
    Adapt.initContext(context);
    return AccusedDetailsScreen(
        comingFromSearchPage: true, accused: results!.toList().first);
  }
}
