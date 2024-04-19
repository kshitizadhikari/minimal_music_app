import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_app/components/login_textField.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  //text editing conttrollers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            //logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/login/music1.png',
                    height: 200, width: 200),
              ],
            ),

            // some text like welcome back
            Text(
              "Please fill out the following form",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),

            const SizedBox(height: 25),
            // user text field
            LoginTextField(
              controller: usernameController,
              obscureText: false,
              hintText: "Username",
            ),

            const SizedBox(height: 25),
            // password text field
            LoginTextField(
              controller: passwordController,
              obscureText: true,
              hintText: "Password",
            ),
            //forgot password

            //sign in button

            //divider - or continue with

            // google image button
          ],
        ),
      ),
    );
  }
}
