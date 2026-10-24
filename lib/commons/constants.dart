import 'package:flutter/material.dart';
import 'package:help_app_flutter/commons/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

String appname = "HELP APP";
double fontSize10 = 10;
double fontSize8 = 8;
double fontSize16 = 16;
double fontSize20 = 20;
double fontSize14 = 14;
double fontSize12 = 12;
double fontSize18 = 18;

SizedBox mCircularProgresIndication = SizedBox(
    height: 20,
    width: 20,
    child: CircularProgressIndicator(strokeWidth: 2.0, color: appThemeColor));
SizedBox wCircularProgresIndication = SizedBox(
    height: 20,
    width: 20,
    child: CircularProgressIndicator(strokeWidth: 2.0, color: whiteColor));

class Constants {
  static SharedPreferences? prefs;
  static String? jwtToken;
  static String version = "8.0";
}
