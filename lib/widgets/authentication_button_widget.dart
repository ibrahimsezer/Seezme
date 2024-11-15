import 'package:flutter/material.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class AuthenticationButtonWidget extends StatelessWidget {
  const AuthenticationButtonWidget({
    super.key,
    required this.function,
    required this.authenticationType,
  });

  final VoidCallback function;

  final String authenticationType;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: defaultTheme.textButtonTheme.style!.backgroundColor),
      onPressed: function,
      child: Text(authenticationType, style: TextStyle(color: Colors.white)),
    );
  }
}
