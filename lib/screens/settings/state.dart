//version 1.0.0+1
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:shared_preferences/shared_preferences.dart';

import '../../export.dart';

class SettingProvider with ChangeNotifier {

  String _username = '';
  String? get username => _username;
  int? _selectedWidget;
  int? get selectedWidget => _selectedWidget;
  int? _radioValue;
  int? get radioValue => _radioValue;

  GoogleSignInAccount? _currentUser;
  int _currantIndex = 0;
  int get currantIndex => _currantIndex;
  GoogleSignInAccount? get currentUser => _currentUser;

  void getCurrentUser(GoogleSignInAccount? current) {
    _currentUser = current;
    notifyListeners();
  }

  void getSelectedWidget(int select) {
    _selectedWidget = select;
    notifyListeners();
  }

  void changeIndex() {
    _currantIndex++;
    notifyListeners();
  }

  void removeFromIndex() {
    _currantIndex--;
    notifyListeners();
  }



//this is for get information user
 void infoUserData()async {
      var userName = await FuSharedPreferences.getString('Username') ?? '';

      _username = userName;
      notifyListeners();
   
  }
 

  void handleValueChange() async {
    var result = await FuSharedPreferences.getString('backupAutomatically');
    if (result == null) {
      await FuSharedPreferences.setString('backupAutomatically', '0');

      notifyListeners();

      _radioValue = 0;
    } else {
      _radioValue = int.parse(result.toString());

      notifyListeners();
    }
    notifyListeners();
  }

  // get Drive Api
  Future<drive.DriveApi?> getDriveApi(context) async {
    final googleSignIn = GoogleSignIn.standard(scopes: [
      drive.DriveApi.driveAppdataScope,
      drive.DriveApi.driveFileScope,
    ]);
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    if (headers == null) {
      UtilsAuth.parseError('Error Sign-in first', context,
          isShowToast: true, colorShowToast: FuAppTheme.customTheme.colorError);
      return null;
    }

    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }
}
