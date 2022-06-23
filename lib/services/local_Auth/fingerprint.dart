//version 1.0.0+1
//------- THIS IS Screen Not Authorized-------//

import 'package:flutter/material.dart';
import 'package:issue/export.dart';
import 'package:issue/services/local_Auth/state.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class NotAuthorized extends StatelessWidget {
  const NotAuthorized({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (context.read<LocalAuthProvider>().authorized.toString() ==
        'Authorized') {
      return const NavigationBarScreen();
    }
    context.read<LocalAuthProvider>().authenticate;
    return Scaffold(
        backgroundColor:
            FuAppTheme.isDarkMode ? Colors.black.withAlpha(60) : Colors.white,
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: IconButton(
                  onPressed: () =>
                      context.read<LocalAuthProvider>().authenticate(),
                  icon: Icon(
                    Icons.fingerprint,
                    color: FuAppTheme.isDarkMode ? Colors.white : Colors.grey,
                    size: 50.sp,
                  )).paddingTop(15.h),
            ),
            ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  FuText.b1('إعادة التحقق', color: Colors.white),
                  Icon(Icons.perm_device_information, color: Colors.white),
                ],
              ),
              onPressed: () => context.read<LocalAuthProvider>().authenticate(),
              //_authenticate,
            ).paddingTop(15.h),
          ],
        ));
  }
}




