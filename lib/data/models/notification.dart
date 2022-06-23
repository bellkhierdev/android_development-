//version 1.0.0+1

class NotificationModel {
  int? id;
  String? name;
  String? typeAlarm;
  String? dateTime;
  String? sentTime;


  NotificationModel(
      {required this.id,
      required this.name,
      required this.typeAlarm,
      required this.dateTime,
      required this.sentTime,
      
      });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    typeAlarm = json['typeAlarm'];
    dateTime = json['dateTime'];
    sentTime = json['sentTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['typeAlarm'] = typeAlarm;
    data['dateTime'] = dateTime;
    data['sentTime'] = sentTime;
    return data;
  }
}
