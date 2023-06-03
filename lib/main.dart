import 'package:chat_app/screen/auth_screen.dart';
import 'package:chat_app/screen/chat_list.dart';
import 'package:chat_app/screen/chat_screen.dart';
import 'package:chat_app/screen/no_internet_screen.dart';
import 'package:chat_app/screen/users_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  @override
  Widget build(BuildContext context) {
//     final FirebaseMessaging messaging = FirebaseMessaging.instance;
// // Set up notification callbacks
//     messaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print(
//           'Received a message in the foreground: ${message.notification?.body}');
//       // Handle the received message
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print(
//           'User tapped on a notification in the foreground: ${message.notification?.body}');
//       // Handle the tapped message
//     });

    return MaterialApp(
      title: 'chat_app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
          background: Colors.purple,
          secondary: Colors.orange,
        ),
        buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.purple,
            textTheme: ButtonTextTheme.primary,
            shape: const RoundedRectangleBorder()),
      ),
      home: FutureBuilder(
        future: checkInternetConnectivity(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.data == true) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (userSnapshot.hasError) {
                  return Center(
                    child: Text(userSnapshot.error.toString()),
                  );
                } else if (userSnapshot.hasData) {
                  return const ChatList();
                } else {
                  return const AuthScreen();
                }
              },
            );
          } else if (snapshot.data == false) {
            return const NoInternetScreen();
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
    );
  }
}
