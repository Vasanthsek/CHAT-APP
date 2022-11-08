// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:io';

//import 'package:cool_chat_app/notification_badge.dart';
//import 'package:cool_chat_app/push_notification.dart';
import 'package:cool_chat_app/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:overlay_support/overlay_support.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // late final FirebaseMessaging _messaging;
  // late int _totalNotificationCounter;

  // PushNotification? _notificationInfo;

  // void registerNotification() async{
  //   await Firebase.initializeApp();
  //   _messaging = FirebaseMessaging.instance;

  //   NotificationSettings settings = await _messaging.requestPermission(alert: true,badge: true,sound: true,provisional: false);
  //   if(settings.authorizationStatus == AuthorizationStatus.authorized){
  //     print("user granted permission");FirebaseMessaging.onMessage.listen((RemoteMessage message) { 
  //       PushNotification notification = PushNotification(
  //         title: message.notification!.title,
  //         body: message.notification!.body,
  //         dataTitle: message.data["title"],
  //         dataBody: message.data["body"],
  //         );
  //         setState(() {
  //           _totalNotificationCounter ++;
  //           _notificationInfo = notification;
  //         });
  //         if(notification != null){
  //           showSimpleNotification(Text(_notificationInfo!.title!),leading: NotificationBadge(totalNotification: _totalNotificationCounter),subtitle: Text(_notificationInfo!.body!),background: Colors.cyan.shade700,duration: const Duration(seconds: 10));
  //         }
  //     });}else{print("permission denied");}
  // }

  final _auth = FirebaseAuth.instance;

  var _isLoading = false;

  Future<void> _submitAuthForm(String email, String password, String username, File? image,
      bool isLogin, BuildContext ctx) async {
    UserCredential? authResult;
    setState(() {
      _isLoading = true;
    });
    if (isLogin) {
      authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } else {
      authResult = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((error) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
              content: Text(
                error.toString(),
              ),
              backgroundColor: Theme.of(ctx).errorColor),
        );
        setState(() {
          _isLoading = false;
        });
      });
      final ref = FirebaseStorage.instance.ref().child("user_image").child("${authResult.user!.uid}.jpg");
      await ref.putFile(image!);
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(authResult.user!.uid)
          .set({
        "username": username,
        "email": email,
        "password": password,
        "userImage":url,
      }).catchError((error) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
              content: Text(
                error.toString(),
              ),
              backgroundColor: Theme.of(ctx).errorColor),
        );
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  // @override
  // void initState() {
  //   _totalNotificationCounter=0;  
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Authform(submitFn: _submitAuthForm, isLoading: _isLoading),
    );
  }
}
