import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enterMessage = "";
  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    // ignore: await_only_futures
    final user = await FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection("chat").add({
      "text": _enterMessage,
      "createdAt": Timestamp.now(),
      "userId": user.uid,
      "username": userData["username"],
      "user_Image":userData["userImage"]
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: "Send a message"),
            onChanged: (value) {
              setState(() {
                _enterMessage = value;
              });
            },
          ),
        ),
        IconButton(
          onPressed: () {
            _enterMessage.trim().isEmpty ? null : _sendMessage();
          },
          icon: const Icon(Icons.send),
          color: Theme.of(context).primaryColor,
        )
      ]),
    );
  }
}
