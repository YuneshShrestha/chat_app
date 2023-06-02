import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  NewMessages({
    Key? key,
    required this.userID1,
    required this.userName1,
    required this.userImage1,
    required this.userID2,
    required this.userName2,
    required this.userImage2,
  }) : super(key: key);
  final String userID1;
  final String userName1;
  final String userImage1;

  final String userID2;
  final String userName2;
  final String userImage2;

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  String message = "";
  bool isSending = false;
  final chatsCollection = FirebaseFirestore.instance.collection('chats');
  List<dynamic>? users;
  QuerySnapshot? snapshot;
  bool isPresent = false;
  String? docPath;
  @override
  void initState() {
    super.initState();
    checkIfPresent();
  }

  void checkIfPresent() async {
    snapshot = await chatsCollection.get();
    users = snapshot!.docs.map((doc) => doc['usersID']).toList();
    for (var user in users!) {
      if (user.contains(widget.userID1) && user.contains(widget.userID2)) {
        docPath = snapshot!.docs[users!.indexOf(user)].id;
        isPresent = true;
      }
    }
  }

  Future<void> pushMessage(
      String senderName, String senderImage, String senderID) async {
    if (!isPresent) {
      await chatsCollection
          .add({
            'timestamp': Timestamp.now(),
            'recentMessage': message,
            'recentSentBy': FirebaseAuth.instance.currentUser!.uid,
            'usersID': [widget.userID1, widget.userID2],
            'usersName': [widget.userName1, widget.userName2],
            'usersImage': [widget.userImage1, widget.userImage2],
          })
          .then((value) => docPath = value.id)
          .onError((error, stackTrace) => 'error');
      await chatsCollection.doc(docPath).collection('chat').add({
        'text': message,
        'createdAt': Timestamp.now(),
        'senderID': senderID,
        'senderName': senderName,
        'senderImage': senderImage,
      });
      isPresent = true;
    } else {
      chatsCollection.doc(docPath).update({
        'timestamp': Timestamp.now(),
        'recentMessage': message,
        'recentSentBy': FirebaseAuth.instance.currentUser!.uid,
      });
      await chatsCollection.doc(docPath).collection('chat').add({
        'text': message,
        'createdAt': Timestamp.now(),
        'senderID': senderID,
        'senderName': senderName,
        'senderImage': senderImage,
      });
    }
  }

  final _messageBoxController = TextEditingController();
  Future<void> sendMessage(String message) async {
    final senderID = FirebaseAuth.instance.currentUser!.uid;
    final senderName = await FirebaseFirestore.instance
        .collection('users')
        .doc(senderID)
        .get();
    setState(() {
      _messageBoxController.clear();
    });

    await pushMessage(senderName['userName'], senderName['imageUrl'], senderID);

    setState(() {
      // _messageBoxController.clear();
      this.message = "";
    });
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
          onPressed: (isSending || message.trim().isEmpty)
              ? null
              : () async {
                  setState(() {
                    isSending = true;
                  });
                  await sendMessage(message);
                  setState(() {
                    isSending = false;
                  });
                },
          icon: const Icon(Icons.send),
        )
      ]),
    );
  }
}
