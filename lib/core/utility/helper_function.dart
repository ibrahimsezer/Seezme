import 'package:flutter/material.dart';

void scrollToBottom(ScrollController _scrollController) {
  if (_scrollController.hasClients) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
