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
    double sizeWidth = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: sizeWidth * 0.7,
      child: ElevatedButton(
        style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            elevation: WidgetStatePropertyAll(1),
            backgroundColor:
                defaultTheme.textButtonTheme.style!.backgroundColor),
        onPressed: function,
        child: Padding(
          padding: PaddingSize.paddingMediumSize,
          child: Text(authenticationType,
              style: TextStyle(color: ConstColors.primaryColor)),
        ),
      ),
    );
  }
}
