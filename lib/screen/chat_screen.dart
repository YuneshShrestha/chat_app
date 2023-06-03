import 'package:chat_app/widgets/chats/messages.dart';
import 'package:chat_app/widgets/chats/new_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.userId1,
    required this.userName1,
    required this.userImage1,
    required this.userId2,
    required this.userName2,
    required this.userImage2,
    required this.docPath,
  });
  final String docPath;

  final String userId1;

  final String userName1;
  final String userImage1;

  final String userId2;

  final String userName2;
  final String userImage2;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatsCollection = FirebaseFirestore.instance.collection('chats');

  // Future<void> updateIsSeen(
  //     String senderName, String senderImage, String senderID) async {
  //   final doc = chatsCollection.doc(widget.docPath);
  //   final docData = await doc.get();
  //   final recentMessageUserID = docData['recentSentBy'];
  //   if (recentMessageUserID != FirebaseAuth.instance.currentUser!.uid) {
  //     await chatsCollection.doc(widget.docPath).update({
  //       'recentIsSeen': true,
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.docPath.isNotEmpty) {
  //     updateIsSeen(widget.userName1, widget.userImage1, widget.userId1);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                (widget.userId1 == FirebaseAuth.instance.currentUser!.uid
                    ? widget.userImage2
                    : widget.userImage1),
              ),
              radius: 16.0,
            ),
            const SizedBox(
              width: 6.0,
            ),
            Text(widget.userId1 == FirebaseAuth.instance.currentUser!.uid
                ? widget.userName2
                : widget.userName1),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(
              userId1: widget.userId1,
              userId2: FirebaseAuth.instance.currentUser!.uid,
              docPath: widget.docPath,
            ),
          ),
          NewMessages(
            userID1: widget.userId1,
            userName1: widget.userName1,
            userImage1: widget.userImage1,
            userID2: FirebaseAuth.instance.currentUser!.uid,
            userName2: widget.userName2,
            userImage2: widget.userImage2,
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
