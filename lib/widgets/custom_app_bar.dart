//version 1.0.0+1

import 'package:flutter/material.dart';
import 'package:issue/export.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

//this is custom AppBar
customAppBar(
  BuildContext context,
) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: SliverAppBar(
      backgroundColor: FuAppTheme.isDarkMode == false
          ? Colors.white
          : FuAppTheme.theme.scaffoldBackgroundColor,
      floating: true,
      snap: true,
      expandedHeight: 12.1,
      title: const Text(
        'مواعيد الحبس',
        style: TextStyle(
          color: Color(0xff3d63ff),
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.2,
        ),
      ),
      centerTitle: false,
      actions: [
        CircleButton(
          icon: Icon(
            Icons.search,
            color: FuAppTheme.isDarkMode == false
                ? Colors.black
                : FuAppTheme.theme.textTheme.bodyText1!.color?.withAlpha(150),
          ),
          iconSize: 30.0,
          color: FuAppTheme.isDarkMode
              ? StyleWidget.cardDark.withAlpha(200)
              : Colors.grey[200],
          onPressed: () => showSearch(
            context: context,
            delegate: SearchBarDelegate(),
          ),
        ),
        //this is icon for change language
        Consumer<HomeScreenProvider>(
          builder: (context, value, child) => CircleButton(
            color: FuAppTheme.isDarkMode == false
                ? Colors.grey[200]
                : StyleWidget.cardDark.withAlpha(200),
            icon: //this is navigator to page notification
                Container(
              padding:
                  EdgeInsets.only(right: value.increment != 0 ? 2 : 2, top: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () => Navigator.push(
                        context, CostumeTransition(const NotificationScreen())),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Icon(
                          MdiIcons.bellOutline,
                          size: value.increment != 0 ? 27 : 27,
                          color: FuAppTheme.isDarkMode == false
                              ? Colors.black
                              : FuAppTheme.theme.textTheme.bodyText1!.color
                                  ?.withAlpha(150),
                        ),
                        Positioned(
                          right: -2,
                          top: -1,
                          child: value.increment != 0
                              ? FuContainer.rounded(
                                  padding: FuSpacing.zero,
                                  height: 16,
                                  width: 20,
                                  color: const Color.fromARGB(255, 234, 20, 0),
                                  child: Center(
                                    child: FuText.overline(
                                      value.increment.toString(),
                                      color: FuAppTheme
                                          .theme.colorScheme.onPrimary,
                                      fontSize: 9,
                                      fontWeight: 900,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            iconSize: 25.0,
            onPressed: () => Navigator.push(
                context, CostumeTransition(const NotificationScreen())),
          ),
        ),

        20.width,
      ],
    ),
  );
}
