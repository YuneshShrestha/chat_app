import 'package:chat_app/screen/chat_screen.dart';
import 'package:chat_app/widgets/animations/rive_animation.dart';
import 'package:chat_app/widgets/chats/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

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
  Artboard? _riveArtboard;
  SMIBool? isEyeClosed;
  @override
  void initState() {
    super.initState();
    // _messageBoxController = TextEditingController();

    try {
      loadRiveFile();

      checkIfPresent().then((value) {
        setState(() {
          isPresent = value[1];
          docPath = value[0];
        });
        // print('$value');
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> loadRiveFile() async {
    final data = await rootBundle.load('assets/teddy.riv');
    try {
      final file = RiveFile.import(data);
      setState(() {
        _riveArtboard = file.mainArtboard;
        if (_riveArtboard != null) {
          var controller = StateMachineController.fromArtboard(
            _riveArtboard!,
            'Login Machine',
          );
          // print("This: $controller  || ${_riveArtboard}");
          if (controller != null) {
            _riveArtboard!.addController(controller);
            // controller.isActive = true;
            isEyeClosed = controller.findSMI('isHandsUp');
          }
        }
      });
    } catch (e) {
      print('Error loading Rive file: $e');
    }
  }

  Future<List<dynamic>> checkIfPresent() async {
    snapshot = await chatsCollection.get();
    print(snapshot!.docs.length);
    users = snapshot!.docs.map((doc) => doc['usersID']).toList();
    print(users!.length);

    if (snapshot!.docs.isNotEmpty || users!.isNotEmpty) {
      for (var user in users!) {
        if (user.contains(widget.userID1) && user.contains(widget.userID2)) {
          return [snapshot!.docs[users!.indexOf(user)].id, true];
        }
      }
    }
    return ['', false];
  }

  Future<void> pushMessage(
      String senderName, String senderImage, String senderID) async {
    if (!isPresent) {
      try {
        await chatsCollection
            .add({
              'timestamp': Timestamp.now(),
              'recentMessage': message,
              'recentSentBy': FirebaseAuth.instance.currentUser!.uid,
              'recentIsSeen': false,
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
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return ChatScreen(
            userId1: widget.userID1,
            userName1: widget.userName1,
            userImage1: widget.userImage1,
            userName2: widget.userName2,
            userImage2: widget.userImage2,
            userId2: widget.userID2,
            docPath: docPath!,
          );
        }));
      } catch (error) {
        print('Error: $error');
      }
    } else {
      try {
        chatsCollection.doc(docPath).update({
          'timestamp': Timestamp.now(),
          'recentMessage': message,
          'recentSentBy': FirebaseAuth.instance.currentUser!.uid,
          'recentIsSeen': false,
        });
        await chatsCollection.doc(docPath).collection('chat').add({
          'text': message,
          'createdAt': Timestamp.now(),
          'senderID': senderID,
          'senderName': senderName,
          'senderImage': senderImage,
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  final _messageBoxController = TextEditingController();
  Future<void> sendMessage(BuildContext context, String message) async {
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
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        // RiveAnimationWidget(),
        _riveArtboard == null
            ? Container()
            : SizedBox(
                width: 60,
                height: 60,
                child: Rive(
                  artboard: _riveArtboard!,
                  fit: BoxFit.cover,
                ),
              ),
        // Switch(
        //     value: isEyeClosed == null ? false : isEyeClosed!.value,
        //     onChanged: (value) {
        //       setState(() {
        //         if (isEyeClosed != null) {
        //           isEyeClosed!.value = value;
        //         }
        //       });
        //     }),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: TextField(
            controller: _messageBoxController,
            decoration: const InputDecoration(
              hintText: 'Enter Message...',
            ),
            onChanged: (val) {
              setState(() {
                message = val;
                if (isEyeClosed != null && message.isNotEmpty) {
                  isEyeClosed!.value = true;
                } else {
                  isEyeClosed!.value = false;
                }
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
                  await sendMessage(context, message);
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
