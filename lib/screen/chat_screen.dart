import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/W5tjXCzVcn9cNKVPrcw2/messages')
              .snapshots(),
          builder: (ctx, streamSnapShot) {
            if (streamSnapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final docs = streamSnapShot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(docs[index]['text']),
                );
              },
            );
          }),
    );
  }
}
