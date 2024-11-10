import 'package:flutter/material.dart';
import 'package:seezme/core/utility/constans/const.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final IconData icon;
  const CustomTextField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        style: TextStyle(color: defaultTheme.primaryColor),
        cursorErrorColor: errorTextStyle.color,
        cursorColor: defaultTheme.primaryColor,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            labelStyle: TextStyle(color: defaultTheme.primaryColor),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: defaultTheme.primaryColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            icon: Icon(icon)),
      ),
    );
  }
}
