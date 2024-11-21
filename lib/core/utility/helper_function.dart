import 'package:flutter/material.dart';

void scrollToBottom(ScrollController _scrollController, BuildContext context) {
  if (_scrollController.hasClients) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + keyboardHeight,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
