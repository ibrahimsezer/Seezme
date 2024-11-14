// FILE: message_model.dart
import 'dart:io';

import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  List<dynamic> _messages = [];
  List<dynamic> get messages => _messages;

  void _addMessage(String message) {
    _messages.add(message);
    notifyListeners();
  }

  get addMessage => _addMessage;

  void _addMediaMessage(File media) {
    _messages.add(media);
    notifyListeners();
  }

  get addMediaMessage => _addMediaMessage;
  void _removeMessage(int index) {
    _messages.removeAt(index);
    notifyListeners();
  }

  get removeMessage => _removeMessage;
}
