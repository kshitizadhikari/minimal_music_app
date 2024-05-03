import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minimal_music_app/components/my_textfield.dart';
import 'package:minimal_music_app/components/my_button.dart';
import 'package:minimal_music_app/components/neu_box.dart';
import 'package:minimal_music_app/components/popup.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, this.onTap});

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
        return MyPopUp(title: 'Login Error', message: message);
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
                //change theme mode
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoSwitch(
                        value: Provider.of<ThemeProvider>(context, listen: false)
                            .isDarkMode,
                        onChanged: (value) =>
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme()),
                  ],
                ),
                //logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/musicLogo1.gif',
                        height: 160, width: 200),


                  ],
                ),

                // some text like welcome back
                Text(
                  "Welcome back!!",
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 25),
                // email text field
                MyTextField(
                  controller: emailController,
                  obscureText: false,
                  hintText: "Enter Email",
                  labelText: "Email",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.email_outlined, color: Theme.of(context).colorScheme.primary,),
                  ),

                ),

                const SizedBox(height: 25),
                // password text field
                MyTextField(
                  controller: passwordController,
                  obscureText: true,
                  hintText: "Enter Password",
                  labelText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.primary,),
                  ),
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
                      text: 'Sign In',
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
                      child: Image.asset("assets/images/login/google.png", height: 50,),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Not a member? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register Now",
                        style: TextStyle(color: Colors.blue),
                      ),
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
