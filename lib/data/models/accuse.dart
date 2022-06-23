//version 1.0.0+1
class Accused {
  int? id;
  String? name;
  String? note;
  int? isCompleted;
  String? date;
  int? phoneNu;
  String? issueNumber;
  String? accused;
  String? sentTime;
  int? firstAlarm;
  int? nextAlarm;
  int? thirdAlert;
  Accused({
    this.id,
    this.name,
    this.note,
    this.isCompleted,
    this.date,
    this.issueNumber,
    this.accused,
    this.phoneNu,
    this.sentTime,
    this.firstAlarm,
    this.nextAlarm,
    this.thirdAlert,
  });
  Accused.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    issueNumber = json['issueNumber'];
    accused = json['accused'];
    phoneNu = json['phoneNu'];
    sentTime = json['sentTime'];
    firstAlarm = json['firstAlarm'];
    nextAlarm = json['nextAlarm'];
    thirdAlert = json['thirdAlert'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['note'] = note;
    data['isCompleted'] = isCompleted;
    data['date'] = date;
    data['phoneNu'] = phoneNu;
    data['issueNumber'] = issueNumber;
    data['accused'] = accused;
    data['sentTime'] = sentTime;
    data['firstAlarm'] = firstAlarm;
    data['nextAlarm'] = nextAlarm;
    data['thirdAlert'] = thirdAlert;
    return data;
  }
}
