import 'package:flutter/material.dart';
import 'package:seezme/core/utility/constans/constants.dart';

void scrollToBottom(ScrollController _scrollController, BuildContext context) {
  if (_scrollController.hasClients) {
    final position = _scrollController.position;
    if (position.maxScrollExtent > 0) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      _scrollController.animateTo(
        position.maxScrollExtent + keyboardHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

void showErrorSnackbar(String message, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showInfoSnackbar(String message, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 1),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showInfoDialog(String title, String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          message,
          style: TextStyle(color: ConstColors.whiteColor),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
