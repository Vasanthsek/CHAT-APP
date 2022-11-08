import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int totalNotification;
  const NotificationBadge({Key? key,required this.totalNotification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(color: Colors.orange,shape: BoxShape.circle),
      child: const Center(child: Padding(padding: EdgeInsets.all(8),child: Text("Total Notification",style: TextStyle(color: Colors.white,fontSize: 20),),)),
    );
  }
}