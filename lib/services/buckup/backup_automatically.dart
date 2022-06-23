//version 1.0.0+1
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:issue/config/config.dart';
import 'package:issue/export.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:provider/provider.dart';
import '../../utils/internet.dart';

import 'package:jiffy/jiffy.dart';

import 'dart:async';
import '../../export.dart';

class BackUpAutomatically {
//------------THIS IS FOR CHECK INTERNET AND CHECK ENABLE DO BACKUP AUTOMATICALLY OR NO --------------//

  void backupAutomatically({
    required BuildContext context,
  }) async {
    try {
      ServicesDatabase().generateBackup().then((contents) async {
        if (contents != 'FJQPi+cJX+KJm8sYAsDYqw==') {
          await CheckInternet.check( url: Config.checkInternetGoogle, timeout: 600) .then((value) async {
      
            if (value.isNotEmpty&& context.read<SettingProvider>().radioValue == 0) {
              await ErrorResponse.awesomeDialog(
                error: "هل تريد انشاء نسخة احتياطية",
                context: context,btnOkText: 'نعم',
                color: Colors.blue,
                dialogType: DialogType.QUESTION,
                btnCancel: 'لا',
                btnOkOnPress: () async {
                  if (contents == 'FJQPi+cJX+KJm8sYAsDYqw==') {
                    await ErrorResponse.showToastWidget(
                        textColor: Colors.white,
                        error: 'يبدو انه لا يوجد لديك بيانات مظافة حالياً');
                  } else {
                    final driveApi =
                        await SettingProvider().getDriveApi(context);
                    if (driveApi == null) {
                      return;
                    }
                    final Stream<List<int>> mediaStream =
                        Future.value(contents.toString().codeUnits)
                            .asStream()
                            .asBroadcastStream();
                    var media =
                        drive.Media(mediaStream, contents.toString().length);

                    // Set up File info
                    var driveFile = drive.File();
                    final timestamp = DateTime.now();
                    await Jiffy.locale(
                        "ar"); //this is for translation date to language arabic
                    final formatter = Jiffy(timestamp).yMMMMEEEEdjm;
                    driveFile.name = "Issus_App-$formatter.txt";
                    driveFile.modifiedTime = DateTime.now().toUtc();
                    driveFile.parents = ["appDataFolder"];

                    // Upload
                    final response = await driveApi.files
                        .create(driveFile, uploadMedia: media)
                        .timeout(
                          const Duration(minutes: 5),
                          onTimeout: () async =>
                              await ErrorResponse.showToastWidget(
                                  error: 'انتهت مهلة الاتصال بالخادم',
                                  colorShowToast: Colors.redAccent),
                        );
                    if (response.toJson().isNotEmpty) {
                      await ErrorResponse.showToastWidget(
                          error: 'تم انشاء نسخة احتياطية بنجاح',
                          colorShowToast: Colors.green);
                    }
                  }
                },
                btnCancelOnPress: () {},
              );
            }
          });
        }
      });
    } on FileSystemException {
      await ErrorResponse.showToastWidget(
          error:
              'Error ==>backupAutomatically  ${const FileSystemException().message}',
          colorShowToast: Colors.green);
      FuLog(const FileSystemException().message);
    } catch (e) {
      await ErrorResponse.showToastWidget(
          error: 'Error ==>backupAutomatically  $e',
          colorShowToast: Colors.redAccent);
      FuLog(e.toString());
    }
  }
}
