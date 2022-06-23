
//version 1.0.0+1

import 'package:url_launcher/url_launcher.dart';

class UtilsAccused {


     //this is for send Message sms
  static Future<dynamic>? smsMessage(String? text) async {
    // Android
    var uri = 'sms:+$text?body=مرحبا%20';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      var uri = 'sms:+$text?body=%20مرحبا';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }


  //this is for coll by phone number
 static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }
 

}
