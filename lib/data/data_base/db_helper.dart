//version 1.0.0


import 'package:issue/export.dart';
import 'package:sqflite/sqflite.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert' as convert;

class DBHelper {
  DBHelper._();
  static final DBHelper db = DBHelper._();
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "tasks";
  static List<String> tables = [];

  //----------- THIS IS FOR INITIALIZE DATABASE -----------//
  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'App.db';
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $_tableName("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "name TEXT, note TEXT, date TEXT, "
          "issueNumber TEXT, accused TEXT, "
          "phoneNu INTEGER, "
          "sentTime TEXT, "
          "firstAlarm INTEGER, "
          "nextAlarm INTEGER, "
          "thirdAlert INTEGER, "
          "isCompleted INTEGER )",
        );
      });
    } catch (e) {
      FuLog('======>Error initDB   $e');
    }
  }

//----------- THIS IS FOR INSERT DATA TO DATABASE -----------//
  static Future<int?> insert(Accused? accused) async {
    try {
      return await _db?.insert(_tableName, accused!.toJson()) ?? 1;
    } catch (e) {
      FuLog('======>Error insert   $e');
      return null;
    }
  }

//----------- THIS IS FOR GET DATA FROM DATABASE -----------//
  Future<List<Accused>?> query() async {
    try {
      var result = await _db!.query(
        _tableName,
      );
      List<Accused>? list;
      if (result.isNotEmpty) {
        list = result.map((e) => Accused.fromJson(e)).cast<Accused>().toList();
      } else {
        list = [];
      }

      return list;
    } catch (e) {
      FuLog('======>Error query   $e');
      return null;
    }
  }

//---------- THIS IS CUSTOM QUERY CASE TIME HAS  NOT EXPIRED------------//
  Future<List<Accused>?> customQueryByNotExpiredTime(
      {required bool forPageNotification}) async {
    List<Map<String, Object?>>? result;

    try {
      if (forPageNotification == true) {
        result = await _db!.rawQuery(
            'SELECT * FROM $_tableName WHERE isCompleted=? and sentTime !=?',
            [0, '']);
      } else {
        result = await _db
            ?.query(_tableName, where: "isCompleted=?", whereArgs: [0]);
      }

      if (result != null) {
        if (result.isNotEmpty) {
          return result
              .map((e) => Accused.fromJson(e))
              .cast<Accused>()
              .toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      FuLog('======>Error customQueryByNotExpiredTime   $e');
      return await ErrorResponse.showToastWidget(
          error: '======>Error customQueryByNotExpiredTime   $e');
    }
  }

//---------- THIS IS CUSTOM QUERY CASE TIME HAS EXPIRED------------//
  Future<List<Accused>> customQueryByExpiredTime() async {
    var result =
        await _db!.query(_tableName, where: 'isCompleted=?', whereArgs: [1]);
    List<Accused>? list;
    if (result.isNotEmpty) {
      list = result.map((e) => Accused.fromJson(e)).cast<Accused>().toList();
    } else {
      list = [];
    }
    return list;
  }

//---------- THIS IS FOR GET ACCUSE BY ID------------//
  Future<List<Accused>> getAccuseById({required int id}) async {
    var result = await _db!.query(_tableName, where: 'id=?', whereArgs: [id]);
    List<Accused>? list;
    if (result.isNotEmpty) {
      list = result.map((e) => Accused.fromJson(e)).cast<Accused>().toList();
    } else {
      list = [];
    }
    return list;
  }

  //---------- This is to get the data that is close to expiration ------------//
  Future<List<Accused>> customQueryByNearExpiredTime() async {
    final List<Map<String, dynamic>> result = await _db!.query(
      _tableName,
      where: "isCompleted IN (?, ? , ?)",
      whereArgs: [1, 2, 3, 4],
    );
    List<Accused>? list;
    if (result.isNotEmpty) {
      list = result.map((e) => Accused.fromJson(e)).cast<Accused>().toList();
    } else {
      list = [];
    }
    return list;
  }

//----------- THIS IS FOR DELETE DATA BY ID FROM DATABASE -----------//
  static delete(Accused accused) async {
    try {
      return await _db!
          .delete(_tableName, where: 'id=?', whereArgs: [accused.id]);
    } catch (e) {
      FuLog('======>Error customQueryByExpiredTime   $e');
    }
  }

//----------- THIS IS FOR UPDATE FIELD [YOUR TABLE] FORM [0] TO ==>[YOUR VALUE]  -----------//
  static Future update(int id, int typeAlarm, String nameField) async {
    try {
      if (nameField == 'isCompleted') {
        return await _db!.rawUpdate('''
    UPDATE tasks
    SET firstAlarm = ?, nextAlarm = ?, thirdAlert = ?, isCompleted = ?
    WHERE id =?
   ''', [0, 0, 0, 1, id]);
      } else {
        return await _db!.rawUpdate('''
    UPDATE tasks
    SET $nameField = ?
    WHERE id =?
   ''', [typeAlarm, id]).then((value) => 1);
      }
    } catch (e) {
      FuLog('======>Error update   $e');
    }
  }

//----------- THIS IS FOR UPDATE FIELD [IS_COMPLETED] FORM [0] TO ==>[Yuer]  -----------//
  static Future updateAllIssue(int id, int typeAlarm, String nameField) async {
    try {
      return await _db!.rawUpdate('''
    UPDATE tasks
    SET $nameField = ?
    WHERE id =?
   ''', [typeAlarm, id]).then((value) => 2);
    } catch (e) {
      FuLog('======>Error update   $e');
    }
  }

//----------- THIS IS FOR UPDATE ALL DATA ACCUSED  -----------//
  static Future<dynamic> updateAccused(Accused accused) async {
    try {
      return await _db!.rawUpdate('''
    UPDATE tasks
    SET name = ?, note = ?, date = ?, issueNumber = ?, accused = ?, phoneNu = ?
    WHERE id =?
   ''', [
        accused.name!,
        accused.note!,
        accused.date!,
        accused.issueNumber!,
        accused.accused!,
        accused.phoneNu!,
        accused.id!
      ]);
    } catch (e) {
      FuLog('======>Error updateAccused   $e');
    }
  }

//----------- THIS IS FOR UPDATE DATA WIEN ALARM ENDS -----------//
  static Future<dynamic> updateWhenAlarmEnd({
    required int id,
    required String typeAlarm,
    required String sentTime,
  }) async {
    //check alarm type
    if (typeAlarm == 'firstAlarm') {
      typeAlarm = 'firstAlarm';
    } else if (typeAlarm == 'nextAlarm') {
      typeAlarm = 'nextAlarm';
    } else if (typeAlarm == 'thirdAlert') {
      typeAlarm = 'thirdAlert';
    }

    try {
      if (typeAlarm == 'thirdAlert') {
        return await _db!.rawUpdate('''
      UPDATE tasks
      SET $typeAlarm = ?, sentTime = ?,isCompleted = ?
      WHERE id =?
      ''', [1, sentTime, 1, id]);
      } else {
        return await _db!.rawUpdate('''
      UPDATE tasks
      SET $typeAlarm = ?, sentTime = ?
      WHERE id =?
      ''', [1, sentTime, id]);
      }
    } catch (e) {
      FuLog('======>Error updateWhenAlarmEnd   $e');
      await ErrorResponse.showToastWidget(
          error: '======>Error updateWhenAlarmEnd   $e');
    }
  }

//----------- THIS IS FOR ENABLE ACCUSED BY ID -----------//
  static Future<dynamic> enableAccused(
      {required int id, required String date}) async {
    try {
      return await _db!.rawUpdate('''
    UPDATE tasks
    SET firstAlarm = ?, nextAlarm = ?, thirdAlert = ?,
     isCompleted = ?,  date = ? 
  
    WHERE id =?
   ''', [0, 0, 0, 0, date, id]);
    } catch (e) {
      FuLog('======>Error enableAccused   $e');
      await ErrorResponse.showToastWidget(
          error: '======>Error enableAccused   $e');
    }
  }

//----------- THIS IS FOR DO  BACKUP FOR ALL DATABASE AND  [encrypted] TO  [base64] -----------//
  static Future<String?> generateBackup({bool isEncrypted = true}) async {
    try {
      var generate = await _db!.query(_tableName);
      List backups = generate.toList();
      String json = convert.jsonEncode(backups);

      if (isEncrypted) {
        var key = encrypt.Key.fromUtf8('Add Here Private Key');
        var iv = encrypt.IV.fromLength(16);
        var encrypter = encrypt.Encrypter(encrypt.AES(key));
        var encrypted = encrypter.encrypt(json, iv: iv);
        return encrypted.base64;
      } else {
        return json;
      }
    } catch (e) {
      FuLog('======>Error delete   $e');
      await ErrorResponse.showToastWidget(error: '======>Error delete   $e');

      return null;
    }
  }

//----------- THIS IS FOR CLEAR ALL TABLES (** NOTE:=> DO THIS AFTER DOING RESTORE BACKUP **)  -----------//
  static Future clearAllTables() async {
    try {
      var dbs = _db;
      for (String table in [_tableName]) {
        await dbs?.delete(table);
        await dbs?.rawQuery("DELETE FROM sqlite_sequence where name='$table'");
      }
    } catch (e) {
      FuLog('======>Error clearAllTables   $e');
      await ErrorResponse.showToastWidget(
          error: '======>Error clearAllTables   $e');
    }
  }

//----------- THIS IS FOR SEARCH BY NAME INSIDE DATABASE -----------//
  Future<List<Accused>?> searchData(String name) async {
    try {
      var result = await _db!
          .rawQuery("SELECT * FROM $_tableName WHERE name LIKE '%$name%'");
      List<Accused>? list;

      if (result.isNotEmpty) {
        list = result.map((e) => Accused.fromJson(e)).cast<Accused>().toList();
      } else {
        list = [];
      }

      return list;
    } catch (e) {
      //print('ERROR==> searchData  $e');
      await ErrorResponse.showToastWidget(error: e.toString());
    }
    return null;
  }

//----------- THIS IS FOR SEARCH BY NAME INSIDE DATABASE -----------//
  Future<List<Accused>?> searchUser(String name) async {
    try {
      var result =
          await _db!.query(_tableName, where: 'name=?', whereArgs: [name]);
      // .rawQuery("SELECT * FROM $_tableName WHERE name LIKE '%$name%'");
      List<Accused>? list;

      if (result.isNotEmpty) {
        list = result.map((e) => Accused.fromJson(e)).cast<Accused>().toList();
      } else {
        list = [];
      }

      return list;
    } catch (e) {
      //print('ERROR==> searchUser  $e');
      await ErrorResponse.showToastWidget(error: e.toString());
    }
    return null;
  }

//----------- THIS IS FOR ADD DATA WHEN USER ENTER ACCOUNT TESTING -----------//
static  Future<int?> addDataTest(List<Map<String, Object?>> data) async {
    try {
      data.forEach((element) async{
        await _db?.insert(_tableName, element) ??
            1;

      });
   
      return null;
    } catch (e) {
      await ErrorResponse.showToastWidget(error: e.toString());
      FuLog('======>Error insert addDataTest  $e');
      return null;
    }
  }

//----------- THIS IS FOR FILTER DATA BY DETAILS NOTIFICATION -----------//
  Future<List<Accused>?> filterByDetailsNotification() async {
    try {
      var result = await _db!.rawQuery(
          'SELECT * FROM $_tableName WHERE isCompleted=? and firstAlarm=? and nextAlarm=? and thirdAlert=?',
          [0, 0, 0, 0]);

      // .rawQuery("SELECT * FROM $_tableName WHERE name LIKE '%$name%'");
      List<Accused>? list;

      if (result.isNotEmpty) {
        list = result.map((e) => Accused.fromJson(e)).cast<Accused>().toList();
      } else {
        list = [];
      }

      return list;
    } catch (e) {
      //print('ERROR==> filterByDetailsNotification  $e');
      await ErrorResponse.showToastWidget(error: e.toString());
    }
    return null;
  }

//----------- THIS IS FOR RESTORE BACKUP TO DATABASE  AND [encrypter] DATA BY PRIVATE_KEY  -----------//
  static Future<void> restoreBackup(String backup,
      {bool isEncrypted = true}) async {
    try {
      var dbs = _db;
      Batch batch = dbs!.batch();
      var key = encrypt.Key.fromUtf8('Add Here Private Key'); //this is private key for encrypt data
      var iv = encrypt.IV.fromLength(16);
      var encrypter = encrypt.Encrypter(encrypt.AES(key));
      List<dynamic> json = convert.jsonDecode(
          isEncrypted ? encrypter.decrypt64(backup, iv: iv) : backup);
      for (var i = 0; i < json.length; i++) {
        Map<String, dynamic> result = Accused(
                accused: json[i]['accused'],
                date: json[i]['date'],
                id: json[i]['id'],
                isCompleted: json[i]['isCompleted'],
                issueNumber: json[i]['issueNumber'],
                name: json[i]['name'],
                note: json[i]['note'],
                phoneNu: json[i]['phoneNu'],
                sentTime: json[i]['sentTime'],
                firstAlarm: json[i]['firstAlarm'],
                nextAlarm: json[i]['nextAlarm'],
                thirdAlert: json[i]['thirdAlert'])
            .toJson();

        batch.insert(_tableName, result);
      }

      await batch.commit(continueOnError: false, noResult: true);
    } catch (e) {
      //  print('ERROR==> restoreBackup  $e');
      await ErrorResponse.showToastWidget(error: e.toString());
    }
    //   FuLog('RESTORE BACKUP successfully');
  }
}
