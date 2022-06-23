class AddDataTest {
  static final List<Map<String, Object?>> data = [
    {
      'note': 'تم القبض علية في مدينة زبيد',
      'accused': ' مداهمة مبنى الاتصالات الخاصة بالجمعية العمومية للصحة العامة',
      'issueNumber': '12-1',
      'name': 'محمد عبدالله بن عبدالله الحارثي',
      'date': DateTime.now().subtract(const Duration(days: 70)).toString(),
      'sentTime': DateTime.now().toString(),
      'firstAlarm': 1,
      'nextAlarm': 1,
      'thirdAlert': 0,
      'isCompleted': 0,
      'phoneNu': 773228215
    },
    {
      'note': 'لم يعترف بقضية الحادثة',
      'accused': 'التهجم على الممتلكات العامة',
      'issueNumber': '33-1',
      'name': 'صالح بن محمد الزيلعي',
      'date': DateTime.now().subtract(const Duration(days: 45)).toString(),
      'sentTime': DateTime.now().toString(),
      'firstAlarm': 1,
      'nextAlarm': 0,
      'thirdAlert': 0,
      'isCompleted': 0,
      'phoneNu': 713228315
    },
    {
      'note': '',
      'accused': 'التخفي تحت مسميات مستعارة لاوجود لها وقتراض مبالغ مالية بغرض الشراكة التجارية',
      'issueNumber': '12-1',
      'name': 'علوي محمد اسامة العولقي',
      'date': DateTime.now().subtract(const Duration(days: 20)).toString(),
      'sentTime': DateTime.now().toString(),
      'firstAlarm': 1,
      'nextAlarm': 0,
      'thirdAlert': 0,
      'isCompleted': 0,
      'phoneNu': 773228315
    },
    {
      'note': '',
      'accused': 'مداهمة معرض مجوهرات',
      'issueNumber': '16-4',
      'name': 'محمد علي صالح القدوسي',
      'date': DateTime.now().subtract(const Duration(days: 10)).toString(),
      'sentTime': DateTime.now().toString(),
      'firstAlarm': 1,
      'nextAlarm': 0,
      'thirdAlert': 0,
      'isCompleted': 0,
      'phoneNu': 703228115
    },
    {
      'note': '',
      'accused': 'تزوير ملفات التعريف لرقابة',
      'issueNumber': '16-4',
      'name': 'سمير محمد عبدة صالح',
      'date': DateTime.now().subtract(const Duration(days: 96)).toString(),
      'sentTime': DateTime.now().toString(),
      'firstAlarm': 0,
      'nextAlarm': 0,
      'thirdAlert': 0,
      'isCompleted': 1,
      'phoneNu': 773228255
    },
    {
      'note': '',
      'accused': 'بيع منتحات منتهية الصلاحية',
      'issueNumber': '22-4',
      'name': 'حمود علي حسن عبدة',
      'date': DateTime.now().subtract(const Duration(days: 1)).toString(),
      'sentTime': DateTime.now().toString(),
      'firstAlarm': 0,
      'nextAlarm': 0,
      'thirdAlert': 0,
      'isCompleted': 0,
      'phoneNu': 773228743
    },
    {
      'note': 'يوجد الى جانبة جماعات متخفية',
      'accused': 'انشاء تراخيص مزورة',
      'issueNumber': '1-12',
      'name': 'نشوان علي صالح البعداني',
      'date': DateTime.now().subtract(const Duration(days: 11)).toString(),
      'sentTime': DateTime.now().toString(),
      'firstAlarm': 1,
      'nextAlarm': 0,
      'thirdAlert': 0,
      'isCompleted': 0,
      'phoneNu': 773221116
    },
    {
      'note': '',
      'accused': 'التهحم بالتوبيخ على مسؤلين الحكومة',
      'issueNumber': '60-2',
      'name': 'عبيد مامون علي عيضة',
      'date': DateTime.now().subtract(const Duration(days: 3)).toString(),
      'sentTime': DateTime.now().toString(),
      'firstAlarm': 0,
      'nextAlarm': 0,
      'thirdAlert': 0,
      'isCompleted': 0,
      'phoneNu': 773228370
    },
  
  ];
}
