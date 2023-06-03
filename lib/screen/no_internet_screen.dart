import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'auth_screen.dart';
import 'chat_list.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                checkInternetAndNavigate(context);
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void checkInternetAndNavigate(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // Internet is available, navigate to the appropriate screen
      // Replace `AuthScreen()` or `ChatList()` with the desired screen
      User? user = FirebaseAuth.instance.currentUser;
      print(user);
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatList()),
        );
      }
    }
  }
}
