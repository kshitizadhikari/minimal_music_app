import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final String labelText;
  final IconButton suffixIcon;
  final Function(String)? onChanged;

  const MyTextField({
    super.key,
    this.controller,
    required this.hintText,
    required this.obscureText,
    required this.labelText,
    required this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          suffixIcon: suffixIcon),
      style: TextStyle(
        color: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }
}
