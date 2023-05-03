import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    void onSubmit(String userName, String password, String email, bool isLogin,
        BuildContext ctx) async {
      UserCredential authResult;
      setState(() {
        isLoading = true;
      });
      try {
        if (!isLogin) {
          authResult = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);

          // Stroing email and username
          FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'userName': userName,
            'email': email,
          });
        } else {
          authResult = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
        }
      }
      // Platform exception for error in firebase
      on PlatformException catch (e) {
        var errorMessage = 'Invalid Credentials';
        if (e.message != null) {
          errorMessage = e.message!;
        }
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
          case "account-exists-with-different-credential":
          case "email-already-in-use":
            errorMessage = "Email already used. Go to login page.";
            break;
          case "ERROR_WRONG_PASSWORD":
          case "wrong-password":
            errorMessage = "Wrong email/password combination.";
            break;
          case "ERROR_USER_NOT_FOUND":
          case "user-not-found":
            errorMessage = "No user found with this email.";
            break;
          case "ERROR_USER_DISABLED":
          case "user-disabled":
            errorMessage = "User disabled.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Too many requests to log into this account.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
          case "operation-not-allowed":
            errorMessage = "Server error, please try again later.";
            break;
          case "ERROR_INVALID_EMAIL":
          case "invalid-email":
            errorMessage = "Email address is invalid.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print(e.toString());
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AuthForm(submitFunction: onSubmit, isLoading: isLoading),
    );
  }
}
