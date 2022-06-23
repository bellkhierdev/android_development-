//version 1.0.0

import 'dart:io';
import 'dart:async';
import '../../export.dart';

class ServicesDatabase {
//------------THIS IS FOR CLEAR ALL DATA FROM DATABASE --------------//

  Future<dynamic> clearAllDatabaseTables() async {
    return await DBHelper.clearAllTables();
  }

//------------THIS IS FOR CREATE BACKUP FOR ALL DATA --------------//

  Future<String?> generateBackup() async {
    return await DBHelper.generateBackup(isEncrypted: true);
  }

//------------THIS IS FOR RESTORE BACKUP FROM GOOGLE DRIVE --------------//
  void restoreBackup(backup) async {
    try {
      await clearAllDatabaseTables().then((value) async =>
          await DBHelper.restoreBackup(backup, isEncrypted: true));
    } on FileSystemException {
      FuLog(const FileSystemException().message);
    } catch (e) {
      FuLog(e.toString());
    }
  }


}
