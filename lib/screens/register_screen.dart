import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minimal_music_app/components/login_textField.dart';
import 'package:minimal_music_app/components/my_button.dart';
import 'package:minimal_music_app/components/neu_box.dart';
import 'package:minimal_music_app/components/popup.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  RegisterScreen({super.key, this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MyPopUp(title: 'Registration Error', message: message);
      },
    );
  }


  void signUserUp() async {
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
      if(passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
      } else {
        showErrorMessage('Passwords do not match');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Dismiss loading dialog upon sign-up failure
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
                        height: 100, width: 100),
                  ],
                ),
                const SizedBox(height: 50),

                // some text like welcome back
                Text(
                  "Let\'s create an account for you!",
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

                // password text field
                LoginTextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  hintText: "Confirm Password",
                ),

                const SizedBox(height: 25),

                //sign in button
                NeuBox(
                    child: MyButton(
                      text: 'Sign Up',
                      onTap: signUserUp,
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

                const SizedBox(height: 25),

                // google image button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeuBox(
                      child: Image.asset("assets/images/login/google.png", height: 40,),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an accont?  ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login",
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
