import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minimal_music_app/components/login_textField.dart';
import 'package:minimal_music_app/components/my_button.dart';
import 'package:minimal_music_app/components/neu_box.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 50,
            width: 100,
            child: Center(
                child: Text(message),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  void signUserIn() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context); // Dismiss loading dialog upon successful sign-in
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Dismiss loading dialog upon sign-in failure
      if (e.code == 'invalid-credential') {
        showErrorMessage('Invalid Credential');
      } else {
        showErrorMessage('Error: ${e.message}'); // Print the error message
        // Handle other errors
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                //logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/login/music1.png',
                        height: 150, width: 150),
                  ],
                ),

                // some text like welcome back
                Text(
                  "Please fill out the following form",
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 25),
                // email text field
                LoginTextField(
                  controller: emailController,
                  obscureText: false,
                  hintText: "Email",
                ),

                const SizedBox(height: 25),
                // password text field
                LoginTextField(
                  controller: passwordController,
                  obscureText: true,
                  hintText: "Password",
                ),

                const SizedBox(height: 25),

                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot Password ?",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),

                //sign in button
                NeuBox(
                    child: MyButton(
                  onTap: signUserIn,
                )),

                const SizedBox(height: 25),

                //divider - or continue with
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '  Or continue with  ',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    const Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // google image button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeuBox(
                      child: Image.asset("assets/images/login/google.png"),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Register Now",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
