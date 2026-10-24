import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart' hide Trans;
import 'package:help_app_flutter/commons/constants.dart';
import 'package:help_app_flutter/screens/authentication_screens/signin_screen.dart';
import 'package:help_app_flutter/screens/main_screens/bottombar_screen/bottombar_screen.dart';
import 'package:help_app_flutter/screens/main_screens/home_screens/notification_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../commons/api_services.dart';
import '../../commons/colors.dart';
import '../../commons/common_functions.dart';
import '../../controllers/local_notification_service.dart';
import '../../controllers/maincontroller.dart';
import '../../controllers/network_connectivity/network_controller.dart';
import 'onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  MainController logoController = Get.put(MainController());
  MainController versionController = Get.put(MainController());
  final NetworkController _networkController = Get.put(NetworkController());

  navigationFunction() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => (onboard != "true")
                    ? const OnboardScreen()
                    : (login != "true")
                        ? const SigninScreen()
                        : const BottomBarScreen(index: 0)));
      }
    });
  }

  String dynamicLogo = "";
  logoFun(context) async {
    dynamic res = await logoController.getLogoFun();
    setState(() {
      dynamicLogo = res['data'];
    });
    firebaseFuns(context);
    if (res != null) {
      versionCheckfun();
    }
  }

  String? onboard;
  String? login;
  String? nav;
  @override
  void initState() {
    super.initState();
    onboard = Constants.prefs!.getString("onboard");
    login = Constants.prefs!.getString("login");
    LocalNotificationService.initialize(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      logoFun(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        height: 30,
        width: double.infinity,
        child: Text(
          "version ${Constants.version}",
          style: TextStyle(
              fontFamily: "Poppins", fontSize: fontSize8, color: orangeColor),
        ),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Obx(() {
            return logoController.isloading.value
                ? mCircularProgresIndication
                : dynamicLogo != ""
                    ? CachedNetworkImage(
                        imageUrl: dynamicLogo.replaceAll("https", "http"),
                        errorWidget: (context, url, error) =>
                            mCircularProgresIndication,
                        height: 200,
                        width: 200,
                      )
                    : Image.asset(
                        "assets/images/Help App.png",
                        height: 200,
                        width: 200,
                      );
          }),
        ),
      ),
    );
  }

  firebaseFuns(cont) async {
    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Get.offAll(() => const NotificationsScreen(from: "pushnotification"));
      }
    });

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_channel', // id
      'My Channel', // title
      importance: Importance.high,
    );

    ///forground work
    FirebaseMessaging.onMessage.listen((message) async {
      if (message != null) {
        print("FM::::${message}");

        LocalNotificationService.display(message);
      }
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("cherry");
      print(message.notification);
      print(message.data);

      Get.to(() => const NotificationsScreen(
            from: "fnotification",
          ));
    });
  }

  var deviceType;
  versionCheckfun() async {
    if (Platform.isAndroid) {
      deviceType = "android";
    } else if (Platform.isIOS) {
      deviceType = "ios";
    }
    Map<String, dynamic> mapdata = {
      "current_version": Constants.version,
      "platform": deviceType,
    };
    dynamic result =
        await Services().postMethod(mapdata, "Home_screen/version");
    print("res version....$result");
    if (result['status'] == "invalid") {
      navigationFunction();
    } else {
      versionDilog(result['message'], result['force_update']);
    }
  }

  versionDilog(String title, String forfulUpdate) {
    return showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (BuildContext cont, StateSetter myState) {
              return AlertDialog(title: Text(title), actions: [
                TextButton(
                    onPressed: () {
                      // launchUrl(Uri.parse(updateLink));
                      if (Platform.isAndroid || Platform.isIOS) {
                        final appId =
                            Platform.isAndroid ? 'com.evergreenhelpapp' : '';
                        final url = Uri.parse(
                          Platform.isAndroid
                              ? "market://details?id=$appId"
                              : "https://apps.apple.com/app/id$appId",
                        );
                        launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    child: Text(
                      "Update Now".tr(),
                      style: TextStyle(color: orangeColor),
                    )),
                if (forfulUpdate == "No" || forfulUpdate == "no")
                  TextButton(
                    child: Text(
                      "Not Now".tr(),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      navigationFunction();
                    },
                  )
              ]);
            }));
  }
}
