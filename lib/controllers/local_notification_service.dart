import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

NotificationDetails notificationDetails = const NotificationDetails(
  android:
      AndroidNotificationDetails("HelpApp", "Help App's notification channel",
          // "this is our channel",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          channelShowBadge: true,
          color: const Color(0xffed1c24)),
);

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool isFlutterLocalNotificationsInitialized = false;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static void initialize(BuildContext context) async {
    const InitializationSettings initializationSettings =
        InitializationSettings(android: AndroidInitializationSettings(
                // "@mipmap/tlogo"
                "logot"), iOS: DarwinInitializationSettings()
            //     iOS: DarwinInitializationSettings(
            // onDidReceiveLocalNotification: onDidReceiveLocalNotification);
            );

    _notificationsPlugin.initialize(initializationSettings
        // onSelectNotification: (String? route) async{
        //   if(route != null){
        //     Navigator.of(context).pushNamed(route);
        //   }
        // }
        );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  static void display(RemoteMessage message) async {
    try {
      print("in display function ma....${message.notification} ");
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // NotificationDetails notificationDetails = NotificationDetails(
      //     android: AndroidNotificationDetails(
      //       "Bhoolink",
      //       "${APPNAME}'s notification channel",
      //       // "this is our channel",
      //       importance: Importance.max,
      //       priority: Priority.high,
      //     ),
      // iOS: const DarwinNotificationDetails(
      //   subtitle: "",
      //   presentSound: true,
      //   presentAlert: true,

      //   // sound:
      // ));

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        // payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
