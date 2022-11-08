// ignore_for_file: avoid_unnecessary_containers

import 'dart:developer';

import 'package:cool_chat_app/notificationservice/local_notification_service.dart';
import 'package:cool_chat_app/widgets/messages.dart';
import 'package:cool_chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // String? mtoken = "";
  // @override
  // void initState() {
    
  //   requestPermission();
  //   getToken();
    
  //   // FirebaseMessaging.onMessage.listen((RemoteMessage message) { 
  //   //   debugPrint("onMessage:");
  //   //     log("onMessage: $message");
  //   //   final snackBar = SnackBar(content: Text(message.notification?.title?? ""));
  //   //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   // });
  //   super.initState();
    
  // }
  // void requestPermission()async{
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print('User granted permission');
  // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //   print('User granted provisional permission');
  // } else {
  //   print('User declined or has not accepted permission');
  // }
  // }

  // Future<void> getToken() async{
  //  await FirebaseMessaging.instance.getToken().then((token) {
  //    setState(() {
  //      mtoken = token;
  //      print("My token is $mtoken");
  //    });
  //  },);
  // }
  @override
  void initState() {
    super.initState();

    // FirebaseMessaging.instance.subscribeToTopic("chat");

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          // LocalNotificationService.display(message);

        }
        LocalNotificationService.display(message);
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    // Future<void> getData() async {
    //   await Firebase.initializeApp();
    //   FirebaseFirestore.instance
    //       .collection('chats/On4ucZjoYT1tRF9d7T6Z/messages')
    //       .snapshots()
    //       .listen((data) {
    //     print(data.docs[0]['text']);
    //   });
    // }

    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Chat"), actions:  [
       IconButton(icon: const Icon(Icons.logout),onPressed: (){FirebaseAuth.instance.signOut();}),
      ]),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
