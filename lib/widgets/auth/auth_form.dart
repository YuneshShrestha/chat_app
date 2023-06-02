import 'dart:io';

import 'package:chat_app/widgets/auth/custom_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(String userName, String password, String email,
      bool isLogin, File? image, BuildContext ctx) submitFunction;
  const AuthForm(
      {super.key, required this.submitFunction, required this.isLoading});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _key = GlobalKey<FormState>();
  bool isLogin = false;
  String userName = "";
  String email = "";
  String password = "";
  File? _pickedImage;
  void onTrySubmit(BuildContext ctx) {
    var isValidated = _key.currentState!.validate();
    // FocusScope.of(context).unfocus() to close keyboard
    FocusScope.of(context).unfocus();
    if (!isLogin && _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please pick your profile image'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }
    if (isValidated) {
      _key.currentState!.save();
      widget.submitFunction(userName.trim(), password.trim(), email.trim(),
          isLogin, _pickedImage, ctx);
    }
  }

  void imagePickingFunction(File image) {
    _pickedImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _key,
              child: Column(
                // mainAxisSize is set to min so that it can take as minimum value as needed and not to take the whle space
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isLogin)
                    CustomImagePicker(
                        imagePickingFunction: imagePickingFunction),
                  TextFormField(
                    key: const ValueKey('emailKey'),
                    validator: (value) {
                      if (value!.isEmpty && !value.contains('@')) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                    ),
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: const ValueKey('userKey'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        userName = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('userNameKey'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty && value.length < 7) {
                        return 'Password must contain atleast 7 characters.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    onSaved: (value) {
                      password = value!;
                    },
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  widget.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            onTrySubmit(context);
                          },
                          child: Text(isLogin ? "Login" : "Sign Up"),
                        ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin ? "Create An Account." : "I have an account.",
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
