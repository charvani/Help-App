import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:help_app_flutter/commons/colors.dart';

dynamic currentBackPressTime;

Future<bool> onWillPop() {
  DateTime now = DateTime.now();

  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(msg: "Tap back again to leave");

    return Future.value(false);
  }
  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  return Future.value(true);
}

toastMesg(String mesg, bool valid) {
  Future<bool?> validToast = Fluttertoast.showToast(
      msg: mesg,
      backgroundColor: valid ? appThemeColor : redColor,
      fontSize: 12,
      gravity: ToastGravity.BOTTOM,
      textColor: whiteColor);
  return validToast;
}

yesNoDilog(BuildContext context, String title, VoidCallback onTap) {
  return showDialog(
      barrierDismissible: false,
      useSafeArea: true,
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
            return AlertDialog(title: Text(title), actions: [
              TextButton(
                  onPressed: onTap,
                  child: Text(
                    "Yes".tr(),
                    style: TextStyle(color: Colors.orange),
                  )),
              TextButton(
                child: Text(
                  "No".tr(),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ]);
          }));
}
