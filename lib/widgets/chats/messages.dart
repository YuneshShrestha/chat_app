import 'package:chat_app/widgets/chats/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        final chatData = snapshot.data?.docs;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) {
            return ChatBubble(
              key: ValueKey(chatData[index].id),
              message: chatData[index]['text'],
              userName: chatData[index]['userName'],
              userImage: chatData[index]['userImage'],
              isMe: chatData[index]['userID'] ==
                  FirebaseAuth.instance.currentUser!.uid,
            );
          },
          itemCount: chatData!.length,
        );
      },
    );
  }
}
