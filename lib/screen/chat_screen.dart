import 'package:chat_app/widgets/chats/messages.dart';
import 'package:chat_app/widgets/chats/new_messages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.userId1,
    required this.userName1,
    required this.userImage1,
    required this.userId2,
    required this.userName2,
    required this.userImage2, required this.docPath,
  });
  final String docPath;

  final String userId1;

  final String userName1;
  final String userImage1;

  final String userId2;

  final String userName2;
  final String userImage2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userId1 == FirebaseAuth.instance.currentUser!.uid
            ? userName2
            : userName1),
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(
              userId1: userId1,
              userId2: FirebaseAuth.instance.currentUser!.uid,
              docPath: docPath,
            ),
          ),
          NewMessages(
            userID1: userId1,
            userName1: userName1,
            userImage1: userImage1,
            userID2: FirebaseAuth.instance.currentUser!.uid,
            userName2: userName2,
            userImage2: userImage2,
            // receiverImage:
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     FirebaseFirestore.instance
      //         .collection('chats/W5tjXCzVcn9cNKVPrcw2/messages')
      //         .add({'text': "Hello I am the new one."});
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
