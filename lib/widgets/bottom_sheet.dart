//version 1.0.0+1

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:issue/export.dart';
import 'dart:io';

class ShowBottomSheet {
  static costumeBottomSheet({
    required final Accused accused,
    required BuildContext context,
    required int key,
    required void Function(void Function() fn) setState,
    required ThemeData themeData,
  }) {
    String weekAlarm = ''.remainingDays(accused.date, 144).toString();
    //this is for check validity data
    String checkWeek = weekAlarm.toString().split('|')[1].toString();
/* This is to see how much is left to alert in the first 45 day */
    String first45DayAlarm = ''.remainingDays(accused.date, 1224).toString();
    //this is for check validity data
    String checkers45Day = first45DayAlarm.toString().split('|')[1].toString();
/* This is to see how much is left to alert in the next 45 day*/
    String next45DayAlarm = ''.remainingDays(accused.date, 2304).toString();
    //this is for check validity data
    String checkNext45Day = next45DayAlarm.toString().split('|')[1].toString();

    String resultWeek = checkWeek != '0'
        ? weekAlarm.toString().split('|')[0].toString() +
            weekAlarm.toString().split('|')[1].toString()
        : weekAlarm.toString().split('|')[0].toString();
    String resultNext = checkNext45Day != '0'
        ? next45DayAlarm.toString().split('|')[0].toString() +
            next45DayAlarm.toString().split('|')[1].toString()
        : next45DayAlarm.toString().split('|')[0].toString();

   
    String resultFirst = checkers45Day != '0'
        ? first45DayAlarm.toString().split('|')[0].toString() +
            first45DayAlarm.toString().split('|')[1].toString()
        : first45DayAlarm.toString().split('|')[0].toString();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          var myProvider = Provider.of<StateAccused>(context, listen: false);

          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: FuAppTheme.isDarkMode == false
                      ? Colors.white
                      : themeData.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(MySize.size16!),
                      topRight: Radius.circular(MySize.size16!))),
              child: Padding(
                padding: EdgeInsets.all(MySize.size16!),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.close_outlined,
                          color: themeData.textTheme.bodyText1!.color,
                        ).onTap(() {
                          Navigator.pop(context);
                        }),
                        //This is Edit Issue
                        Expanded(
                          child: ListTile(
                            dense: true,
                            leading: Icon(MdiIcons.contentSaveEditOutline,
                                color: themeData.colorScheme.onBackground
                                    .withAlpha(220)),
                            title: Text(
                              "تعديل",
                              style: themeData.textTheme.bodyText1!.merge(
                                  TextStyle(
                                      color:
                                          themeData.textTheme.bodyText1!.color,
                                      letterSpacing: 0.3,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  CostumeTransition(AddAccusedScreen(
                                    accused: accused,
                                  )));
                            },
                          ),
                        ),
                      ],
                    ),
                    //This is share Issue
                    listTile(
                        themeData: themeData,
                        leading: Icon(MdiIcons.shareOutline,
                            color: themeData.colorScheme.onBackground
                                .withAlpha(220)),
                        text: "مشاركة",
                        context: context,
                        key: key,
                        onTap: () async {
                          Navigator.pop(context);
                          DateTime dateTime = DateTime.parse(
                            accused.date.toString(),
                          );
                          var thisWeek =
                              dateTime.add(const Duration(hours: 144));
                          var firstNoti =
                              dateTime.add(const Duration(hours: 1224));
                          var nextNoti =
                              dateTime.add(const Duration(hours: 2304));
                          final invoice = Invoice(
                            supplier: const Supplier(
                              name: 'تفاصل المتهم',
                              address: 'نجيب اسماعيل عبدة علي عسلان',
                              paymentInfo: 'https://paypal.me/sarahfieldzz',
                            ),
                            customer: const Customer(
                              name: 'الملاحضة',
                              address:
                                  'نجيب اسماعيل عبدة علي عسلان نجيب اسماعيل عبدة علي عسلان',
                            ),
                            items: [
                              InvoiceItem(
                                  description: 'التنبية الاول',
                                  date: '${''.splitsDate(thisWeek.toString())}',
                                  unitPrice: resultWeek),
                              InvoiceItem(
                                  description: 'التنبية الثاني',
                                  date:
                                      '${''.splitsDate(firstNoti.toString())}',
                                  unitPrice: resultFirst),
                              InvoiceItem(
                                  description: 'التنبية الثالث',
                                  date: '${''.splitsDate(nextNoti.toString())}',
                                  unitPrice: resultNext),
                            ],
                          );

                          var nameUser =
                              accused.name.toString().trim().split(' ');
                          var fullName = nameUser.first + ' ' + nameUser.last;
                          final pdfFile = await PdfParagraphApi.generate(
                              fullName, accused, invoice);

                          List<String>? files = [
                            PlatformFile(
                              name: 'najeeb',
                              size: 55454,
                              readStream: null,
                              bytes: null,
                            )
                          ]
                              .map(
                                (file) => pdfFile.path.toString(),
                              )
                              .cast<String>()
                              .toList();
                          if (files.isEmpty) {
                            return;
                          }
                          //this is for only read pdf
                          // PdfApi.openFile(pdfFile);

                          //this is for share pdf
                          await Share.shareFiles(files).then((value) {
                            File(pdfFile.path)
                                .delete(recursive: true)
                                .then((value) {
                            }).onError((error, stackTrace) {
                            });
                          });
                        },
                        setState: setState,
                        sizeText: 20),

                    //This is finished Issue
                    accused.isCompleted ==
                            0 //this is  if Issue already is isCompleted do not show this widget
                        ? listTile(
                            themeData: themeData,
                            leading: Icon(MdiIcons.storeRemoveOutline,
                                color: themeData.colorScheme.onBackground
                                    .withAlpha(220)),
                            text: "انهاء",
                            context: context,
                            key: key,
                            onTap: () {
                              ErrorResponse.awesomeDialog(
                                error:
                                    ' سوف يتم انهاء تهمة ${accused.name!.split(' ')[0]} ',
                                context: context,
                                dialogType: DialogType.QUESTION,
                                color: Colors.blue,
                                btnCancel: 'الغاء',
                                btnOkOnPress: () async {
                                  setState(() {
                                    myProvider.accuseCompleted(
                                        accused.id!, context, 1);
                                  });

                                  key == 0
                                      ? Navigator.pop(context)
                                      : Navigator.pop(context);
                                },
                                btnCancelOnPress: () {
                                  Navigator.pop(context);
                                },
                              );
                            },
                            setState: setState,
                            sizeText: 20)
                        : const SizedBox(),
                    //This is delete Issue
                    listTile(
                        themeData: themeData,
                        leading: Icon(MdiIcons.deleteOutline,
                            color: themeData.colorScheme.onBackground
                                .withAlpha(220)),
                        text: "حذف",
                        context: context,
                        key: key,
                        onTap: () {
                          return ErrorResponse.awesomeDialog(
                              error:
                                  ' سوف يتم حذف المتهم ${accused.name!.split(' ')[0]}',
                              context: context,
                              dialogType: DialogType.QUESTION,
                              color: Colors.blue,
                              btnCancel: 'الغاء',
                              btnCancelOnPress: () {
                                Navigator.pop(context);
                              },
                              btnOkOnPress: () {
                                setState(() {
                                  context.read<StateAccused>().delete(accused);
                                });

                                key == 0
                                    ? Navigator.pop(context)
                                    : Navigator.push(
                                        context,
                                        CostumeTransition(
                                            const NavigationBarScreen()));
                              });
                        },
                        setState: setState,
                        sizeText: 20),
                    //This is download pdf Issue
                    // listTile(
                    //     themeData: themeData,
                    //     leading: Icon(MdiIcons.downloadOutline,
                    //         color: themeData.colorScheme.onBackground
                    //             .withAlpha(220)),
                    //     text: "تنزيل",
                    //     context: context,
                    //     key: key,
                    //     onTap: () {},
                    //     setState: setState,
                    //     sizeText: 20),
                  ],
                ),
              ),
            ),
          );
        });
  }

  //This is OPP ListTile
  static Widget listTile(
      {required themeData,
      required Widget leading,
      required String text,
      required BuildContext context,
      required int key,
      required Function() onTap,
      required void Function(void Function() fn) setState,
      required double sizeText}) {
    return ListTile(
        dense: true,
        leading: leading,
        title: Text(
          text,
          style: themeData.textTheme.bodyText1!.merge(TextStyle(
              color: themeData.colorScheme.onBackground,
              letterSpacing: 0.3,
              fontSize: sizeText,
              fontWeight: FontWeight.w500)),
        ),
        onTap: onTap);
  }
}
