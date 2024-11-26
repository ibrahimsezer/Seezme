import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    required this.textColor,
  });
  final VoidCallback onPressed;
  final String text;
  final WidgetStateProperty<Color?>? backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(backgroundColor: backgroundColor),
        onPressed: () => onPressed(),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ));
  }
}
