//version 1.0.0+1

import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/documents.readonly',
    'https://www.googleapis.com/auth/drive.readonly'
  ],
);

class AuthManager {
  //------------ THIS IS FOR SIGN IN WITH GOOGLE --------------//

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      //print('account: ${account?.toString()}');
      return account;
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString(), webPosition: 'center');
     // print(error);
      return null;
    }
  }

  static Future<GoogleSignInAccount?> signInSilently() async {
    var account = await _googleSignIn.signInSilently();
   // print('account: $account');
    return account;
  }

//------------THIS IS FOR LOGOUT FROM GOOGLE--------------//
  static Future<void> signOut() async {
    try {
      _googleSignIn.disconnect();
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString(), webPosition: 'center');
    //  print(error);
    }
  }
}
