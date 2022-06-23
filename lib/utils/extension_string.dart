
//version 1.0.0+1
import 'package:flutter_utils_project/src/utils/extensions/string_extensions.dart';
import 'package:jiffy/jiffy.dart';

extension ExtensionString on String {
  differentTime(String? date, number) {
 
    ///  هذا لعرض متى انتهاء الإشعارات او اشعارات المتهم كلهم
    final startTime =DateTime.parse(date!.toString()).add(Duration(hours: number));
   // print(DateTime.now().difference(startTime).inDays ~/ 360);
    DateTime onlyDate = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
      7,

      ///same this is time = 07:00 AM
    );



    ///this is Decrease the date of entry of the Issued from our current date
    var result = Jiffy(onlyDate).yMMMMEEEEdjm;
    var year = result.toString().split(' ')[3].toString();
    var month = result.toString().split(' ')[1].toString();
    var day = result.toString().split(' ')[2].toString();
    var time = result.toString().split(' ,')[0].toString().split(year)[1];
    var nameDay = result.toString().split(',')[0].toString();
    return '$year|${monthTranslation(month)}|${day.toString().split(',')[0]}|${daysTransition(nameDay.toString())}|${periodTime(time.split(' ')[1].toString() + '|' + time.split(' ')[2].toString())}';
  }


  ///this is for transition Months
  monthTranslation(month) {
    if (month == 'January') {
      return month = 'يناير';
    }
    if (month == 'February') {
      return month = 'فبراير';
    }
    if (month == 'March') {
      return month = 'مارس';
    }
    if (month == 'April') {
      return month = 'أبريل';
    }
    if (month == 'May') {
      return month = 'مايو';
    }
    if (month == 'June') {
      return month = 'يونيو';
    }
    if (month == 'July') {
      return month = 'يوليو';
    }
    if (month == 'August') {
      return month = 'أغسطس';
    }
    if (month == 'September') {
      return month = 'سبتمبر';
    }
    if (month == 'October') {
      return month = 'أكتوبر';
    }
    if (month == 'November') {
      return month = 'نوفمبر';
    }
    if (month == 'December') {
      return month = 'ديسمبر';
    }
     if (month == 'Saturday') {
      return month = 'السبت';
    }
    if (month == 'Friday') {
      return month = 'الجمعة';
    }
    if (month == 'Thursday') {
      return month = 'الخميس';
    }
    if (month == 'Wednesday') {
      return month = 'الأربعاء';
    }
    if (month == 'Tuesday') {
      return month = 'الثلاثاء';
    }
    if (month == 'Monday') {
      return month = 'الإثنين';
    }
    if (month == 'Sunday') {
      return month = 'الأحَد';
    }
  }



  ///this is for transition Days
  daysTransition(day) {
    if (day == 'Saturday') {
      return day = 'السبت';
    }
    if (day == 'Friday') {
      return day = 'الجمعة';
    }
    if (day == 'Thursday') {
      return day = 'الخميس';
    }
    if (day == 'Wednesday') {
      return day = 'الأربعاء';
    }
    if (day == 'Tuesday') {
      return day = 'الثلاثاء';
    }
    if (day == 'Monday') {
      return day = 'الإثنين';
    }
    if (day == 'Sunday') {
      return day = 'الأحَد';
    }
  }

  ///this is for get period time for example AM - PM
  periodTime(String? period) {
    period!.split('|').toString();

    if (period.split('|')[1] == 'AM') {
      return period.split('|')[0].toString() + ' ص';
    } else if (period.split('|')[1].toString() == 'PM') {
      return period.split('|')[0].toString() + ' م';
    }
  }

String myReplaceFarsiNumber(String input) {
  const english = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
    'AM',
    'PM',
    'Saturday',
    'Friday',
    'Thursday',
    'Wednesday',
    'Tuesday',
    'Monday',
    'Sunday',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];

  const farsi = [
    //months
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
    //evening and morning
    'ص',
    'م',
    //days
    'السبت',
    'الجمعة',
    'الخميس',
    'الأربعاء',
    'الثلاثاء',
    'الإثنين',
    'الأحَد',
    //number
    '۰',
    '۱',
    '۲',
    '۳',
    '٤',
    '٥',
    '٦',
    '۷',
    '۸',
    '۹',
  ];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], farsi[i]);
  }

  return input;
}

  /// this is for Remaining days until the end of the alert
  remainingDays( date,alarm,) {
    String? result;

    ///This is to compare the (week or first 45 day or next 45 day) after the date of his entry to the date of his entry,
    ///and to obtain the remaining days for a (week or first 45 day or next 45 day) after his entry
    final dateAftreWeek =DateTime.parse(date!.toString()).add(Duration(hours: alarm));
    var dates = DateTime.now();
    DateTime onlyDate = DateTime(
      dates.year,
      dates.month,
      dates.day,
    );

    final diffDy = onlyDate.difference(dateAftreWeek).inDays;
    final diffHr = onlyDate.difference(dateAftreWeek).inHours;
    final diffMi1 = onlyDate.difference(dateAftreWeek).inMinutes;
    if (diffDy.toString().startsWith('-')) {
      if (diffDy != 0) {
        return result = '${diffDy.toString().split('-')[1]}|  يوم';
      } else if (diffDy == 0) {
        if (diffHr != 0) {
          return result = '${diffHr.toString().toString().split('-')[1]}| ساعة';
        } else if (diffMi1 != 0) {
          return result =
              ' ${diffMi1.toString().toString().split('-')[1]}| دقيقة';
        } else {
          return result = 'المدة مكتملة |0';
        }
      }
    } else {
      return result = 'المدة مكتملة |0';
    }
  }



  //this is split eny date
  splitsDate(date) {
    return date.toString().split(' ')[0].toString();
  }



  /// this is decodeDate
  decodeDate(date, int key) {
    if (key == 0) {
      return replaceFarsiNumber(date.toString().split('|')[0].toString()) +
          " ," +
          replaceFarsiNumber(date.toString().split('|')[3].toString()) +
          " ," +
          replaceFarsiNumber(date.toString().split('|')[2].toString()) +
          " " +
          replaceFarsiNumber(date.toString().split('|')[1].toString());
    } else {
      var time =
          date.toString().split('|')[4].toString().split(':')[0].toString();

      return replaceFarsiNumber(date.toString().split('|')[0].toString()) +
          " ," +
          replaceFarsiNumber(date.toString().split('|')[3].toString()) +
          " ," +
          replaceFarsiNumber(date.toString().split('|')[2].toString()) +
          " " +
          replaceFarsiNumber(date.toString().split('|')[1].toString()) +
          " " +
          replaceFarsiNumber(', ' +
              time +
              date.toString().split('|')[4].toString().split('00')[1]);
    }
  }



  /// this is replies data will not have
  repliesDate1(label, int number) {
    return ''.differentTime(label.toString(), number);
  }



  replisDate(lable, int number) {
    return ''.differentTime(lable.toString().split("|")[1].toString(), number);
  }



  ///  name abbreviation
  nameAbbreviation(String value) {
    if (value.toString().split(' ').first == value.toString().split(' ').last) {
      return value.toString().split(' ').first;
    } else {
      return value.toString().split(' ').first +
          ' ' +
          value.toString().split(' ').last;
    }
  }
}
