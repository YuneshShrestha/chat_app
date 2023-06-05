import 'package:chat_app/widgets/chats/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Messages extends StatefulWidget {
  const Messages(
      {Key? key,
      required this.userId1,
      required this.userId2,
      required this.docPath})
      : super(key: key);

  final String userId1;
  final String userId2;
  final String docPath;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final chatsCollection = FirebaseFirestore.instance.collection('chats');
  final senderID = FirebaseAuth.instance.currentUser!.uid;
  String? docPath;
  List<dynamic>? users;
  QuerySnapshot? snapshot;
  bool isPresent = false;
  // @override
  // void initState() {
  //   super.initState();
  //   checkIfPresent();
  // }

  Future<void> checkIfPresent() async {
    snapshot = await chatsCollection.get();
    users = snapshot!.docs.map((doc) => doc['usersID']).toList();
    for (var user in users!) {
      if (user.contains(widget.userId1) && user.contains(widget.userId2)) {
        docPath = snapshot!.docs[users!.indexOf(user)].id;
        isPresent = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: checkIfPresent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(docPath)
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            // print("Path: $docPath");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('No chat messages available. Start a new chat.'),
                ],
              );
            }

            final chatData = snapshot.data!.docs;

            return ListView.builder(
              reverse: true,
              itemBuilder: (ctx, index) {
                return ChatBubble(
                  key: ValueKey(chatData[index].id),
                  message: chatData[index]['text'],
                  senderImage: chatData[index]['senderImage'],
                  senderName: chatData[index]['senderName'],
                  isMe: chatData[index]['senderID'] ==
                      FirebaseAuth.instance.currentUser!.uid,
                );
              },
              itemCount: chatData.length,
            );
          },
        );
      },
    );
  }
}
