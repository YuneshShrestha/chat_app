import 'package:chat_app/widgets/chats/messages.dart';
import 'package:chat_app/widgets/chats/new_messages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatApp"),
        actions: [
          DropdownButton(
              icon: Icon(Icons.more_vert,
                  color: Theme.of(context).primaryIconTheme.color),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: SizedBox(
                    child: Row(
                      children: const [
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 6.0,
                        ),
                        Text("LogOut"),
                      ],
                    ),
                  ),
                )
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == "logout") {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: Messages(),
          ),
          NewMessages(),
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
