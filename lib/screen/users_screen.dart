import 'package:chat_app/screen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        // actions: [
        //   DropdownButton(
        //       underline: Container(),
        //       icon: Icon(Icons.more_vert,
        //           color: Theme.of(context).primaryIconTheme.color),
        //       items: [
        //         DropdownMenuItem(
        //           value: 'logout',
        //           child: SizedBox(
        //             child: Row(
        //               children: const [
        //                 Icon(Icons.exit_to_app),
        //                 SizedBox(
        //                   width: 6.0,
        //                 ),
        //                 Text("LogOut"),
        //               ],
        //             ),
        //           ),
        //         )
        //       ],
        //       onChanged: (itemIdentifier) {
        //         if (itemIdentifier == "logout") {
        //           FirebaseAuth.instance.signOut();
        //         }
        //       })
        // ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          } else {
            final docs = snapshot.data!.docs;
            final user2 = snapshot.data!.docs
                .firstWhere((element) => element.id == user!.uid);

            return ListView.builder(
              itemBuilder: (ctx, index) {
                return ListTile(
                  onTap: () async {
                    final chatsCollection =
                        FirebaseFirestore.instance.collection('chats');

                    final QuerySnapshot snapshot = await chatsCollection.get();
                    // print(snapshot.docs.map((doc) => doc.id).toList());
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        docPath: '',
                        userId1: docs[index].id,
                        userName1: docs[index]['userName'],
                        userImage1: docs[index]['imageUrl'],
                        userId2: FirebaseAuth.instance.currentUser!.uid,
                        userName2: user2['userName'],
                        userImage2: user2['imageUrl'],
                      ),
                    ));
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(docs[index]['imageUrl']),
                  ),
                  title: Text(
                    docs[index]['userName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    docs[index]['email'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              itemCount: docs.length,
            );
          }
        },
      ),
    );
  }
}
