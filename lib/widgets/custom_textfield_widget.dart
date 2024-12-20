import 'package:flutter/material.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final IconData icon;
  final String hintText;
  final String title;
  const CustomTextField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    required this.icon,
    required this.title,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: ConstColors.secondaryColor,
                  fontSize: FontSize.titleFontSize,
                  fontWeight: FontWeight.bold)),
          TextField(
            style: TextStyle(color: ConstColors.primaryColor),
            cursorErrorColor: errorTextStyle.color,
            cursorColor: defaultThemeLight.primaryColor,
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              suffixIconColor: ConstColors.blackLicorice,
              suffixIcon: Icon(icon),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              labelStyle: TextStyle(color: defaultThemeLight.primaryColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: defaultThemeLight.primaryColor),
                borderRadius: BorderRadius.circular(5.0),
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
