import 'package:chat_app/screen/chat_screen.dart';
import 'package:chat_app/screen/users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatApp"),
        actions: [
          DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                  icon: Icon(Icons.more_vert,
                      color: Theme.of(context).primaryIconTheme.color),
                  items: [
                    DropdownMenuItem(
                      value: 'users',
                      child: SizedBox(
                        child: Row(
                          children: const [
                            Icon(
                              Icons.supervised_user_circle,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 6.0,
                            ),
                            Text("Users"),
                          ],
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'logout',
                      child: SizedBox(
                        child: Row(
                          children: const [
                            Icon(
                              Icons.exit_to_app,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 6.0,
                            ),
                            Text("LogOut"),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onChanged: (itemIdentifier) {
                    if (itemIdentifier == "logout") {
                      FirebaseAuth.instance.signOut();
                    } else if (itemIdentifier == "users") {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const UsersScreen()));
                    }
                  }),
            ),
          ),
          // IconButton(
          //     onPressed: () => Navigator.of(context).push(
          //         MaterialPageRoute(builder: (ctx) => const UsersScreen())),
          //     icon: const Icon(Icons.supervised_user_circle)),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('usersID', arrayContains: user!.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong ${snapshot.error}}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No chats yet. Start a new chat!"),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const UsersScreen())),
                      child: const Text("View Users"))
                ],
              ),
            );
          } else {
            final docs = snapshot.data!.docs;
            // return Text(docs[].toString());
            return ListView.builder(
              itemBuilder: (ctx, index) {
                return ListTile(
                  onTap: () async {
                    final docPath = docs[index].id;

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ChatScreen(
                              docPath: docPath,
                              userId1: docs[index]['usersID'][0],
                              userName1: docs[index]['usersName'][0],
                              userImage1: docs[index]['usersImage'][0],
                              userId2: docs[index]['usersID'][1],
                              userName2: docs[index]['usersName'][1],
                              userImage2: docs[index]['usersImage'][1],
                            )));
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      docs[index]['usersID'][0] == user.uid
                          ? docs[index]['usersImage'][1]
                          : docs[index]['usersImage'][0],
                    ),
                  ),
                  title: Text(
                    docs[index]['usersID'][0] == user.uid
                        ? docs[index]['usersName'][1]
                        : docs[index]['usersName'][0],
                    style: TextStyle(
                      fontWeight: (docs[index]['recentIsSeen'] ||
                              docs[index]['recentSentBy'] == user.uid)
                          ? FontWeight.w400
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        docs[index]['recentSentBy'] == user.uid
                            ? "You: "
                            : docs[index]['usersID'][0] == user.uid
                                ? "${docs[index]['usersName'][1]}: "
                                : "${docs[index]['usersName'][0]}: ",
                        style: TextStyle(
                          fontWeight: (docs[index]['recentIsSeen'] ||
                                  docs[index]['recentSentBy'] == user.uid)
                              ? FontWeight.w400
                              : FontWeight.bold,
                        ),
                      ),
                      Text(
                        docs[index]['recentMessage'].toString().substring(
                            0,
                            docs[index]['recentMessage'].toString().length > 12
                                ? 12
                                : docs[index]['recentMessage']
                                    .toString()
                                    .length),
                        style: TextStyle(
                          fontWeight:
                              (docs[index]['recentSentBy'] == user.uid ||
                                      docs[index]['recentIsSeen'])
                                  ? FontWeight.w400
                                  : FontWeight.bold,
                        ),
                      ),
                      if (docs[index]['recentMessage'].toString().length > 12)
                        const Text("..."),
                      const Spacer(),
                      Text(
                        GetTimeAgo.parse(
                          DateTime.parse(
                              docs[index]['timestamp'].toDate().toString()),
                          pattern: "dd-MM-yyyy hh:mm aa",
                        ),
                        style: TextStyle(
                          fontWeight: (docs[index]['recentIsSeen'] ||
                                  docs[index]['recentSentBy'] == user.uid)
                              ? FontWeight.w400
                              : FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 12.0,
                        ),
                      ),
                      // Text(
                      //   '${docs[index]['timestamp'].toDate().hour}:${docs[index]['timestamp'].toDate().minute}',
                      //   style: TextStyle(
                      //     fontWeight: (docs[index]['recentIsSeen'] ||
                      //             docs[index]['recentSentBy'] == user.uid)
                      //         ? FontWeight.w400
                      //         : FontWeight.bold,
                      //     fontStyle: FontStyle.italic,
                      //   ),
                      // ),
                    ],
                  ),
                  // subtitle: Text(
                  //   docs[index].id,
                  // ),
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
