// FILE: message_model.dart
import 'dart:io';

import 'package:flutter/material.dart';

class MessageModel with ChangeNotifier {
  List<dynamic> _messages = [];
  List<dynamic> get messages => _messages;

  void addMessage(String message) {
    _messages.add(message);
    notifyListeners();
  }

  void addMediaMessage(File media) {
    _messages.add(media);
    notifyListeners();
  }

  void removeMessage(int index) {
    _messages.removeAt(index);
    notifyListeners();
  }
}
