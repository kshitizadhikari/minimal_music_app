import 'package:flutter/material.dart';

class MyPopUp extends StatelessWidget {

  final String title;
  final String message;

  const MyPopUp({super.key, required this.title, required this.message});

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        height: 50,
        child: Center(
          child: Text(message),
        ),
      ),
      shape: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(20)
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
