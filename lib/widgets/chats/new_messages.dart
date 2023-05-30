import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  NewMessages({Key? key}) : super(key: key);

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  String message = "";
  final _messageBoxController = TextEditingController();
  void sendMessage(String message) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final userName =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': message,
      'createdAt': Timestamp.now(),
      'userID': userID,
      'userName': userName['userName'],
      'userImage': userName['imageUrl'],
    });
    _messageBoxController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10.0,
      ),
      padding: const EdgeInsets.all(
        6.0,
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _messageBoxController,
            decoration: const InputDecoration(
              hintText: 'Enter Message...',
            ),
            onChanged: (val) {
              setState(() {
                message = val;
              });
            },
          ),
        ),
        IconButton(
          onPressed: message.trim().isEmpty
              ? null
              : () {
                  sendMessage(message);
                },
          icon: const Icon(Icons.send),
        )
      ]),
    );
  }
}
