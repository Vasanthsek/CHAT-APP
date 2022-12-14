// ignore_for_file: prefer_const_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static void initialize()  {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(initializationSettings);
  }
static void display(RemoteMessage message)async{
  try {
  final id = DateTime.now().millisecondsSinceEpoch ~/1000;
  final NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      "easyapproach",
      "easyapproach channel",
      channelDescription: "this is our channel",
      importance: Importance.max,
      priority: Priority.high,
      
  )
  );
  await _notificationsPlugin.show(id, message.notification!.title, message.notification!.body, notificationDetails);
} on Exception catch (e) {
  print(e);
}
}

}
