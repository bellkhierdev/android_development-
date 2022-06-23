//version 1.0.0+1

import 'package:issue/export.dart';

class FunctionGlobal {
  static thirdAlarm({required String date}) {
/* This is to see how much is left to alert in the next 45 day*/
    String next45DayAlarm = ''.remainingDays(date, 2304).toString();
    //this is for check validity data
    String checkNext45Day = next45DayAlarm.toString().split('|')[1].toString();

    String resultNext = checkNext45Day != '0'
        ? next45DayAlarm.toString().split('|')[0].toString() +
            next45DayAlarm.toString().split('|')[1].toString()
        : next45DayAlarm.toString().split('|')[0].toString();

    return resultNext.trim() == 'المدة مكتملة'
        ? ''.replaceFarsiNumber(resultNext)
        : 'يتبقى:${''.replaceFarsiNumber(resultNext)}';
  }

  static nextAlarm({required String date}) {
    /* This is to see how much is left to alert in the first 45 day */
    String first45DayAlarm = ''.remainingDays(date, 1224).toString();
    //this is for check validity data
    String checkFirst45Day =
        first45DayAlarm.toString().split('|')[1].toString();

    String resultFirst = checkFirst45Day != '0'
        ? first45DayAlarm.toString().split('|')[0].toString() +
            first45DayAlarm.toString().split('|')[1].toString()
        : first45DayAlarm.toString().split('|')[0].toString();
    return resultFirst.trim() == 'المدة مكتملة'
        ? ''.replaceFarsiNumber(resultFirst)
        : 'يتبقى:${''.replaceFarsiNumber(resultFirst)}';
  }

  static firstAlarm({required String date}) {
    /* This is to see how much is left to alert in the first week */
    String weekAlarm = ''.remainingDays(date, 144).toString();
    //this is for check validity data
    String checkWeek = weekAlarm.toString().split('|')[1].toString();

    String resultWeek = checkWeek != '0'
        ? weekAlarm.toString().split('|')[0].toString() +
            weekAlarm.toString().split('|')[1].toString()
        : weekAlarm.toString().split('|')[0].toString();

    return resultWeek.trim() == 'المدة مكتملة'
        ? ''.replaceFarsiNumber(resultWeek)
        : 'يتبقى:${''.replaceFarsiNumber(resultWeek)}';
  }
}
