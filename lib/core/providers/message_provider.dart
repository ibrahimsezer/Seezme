// FILE: message_model.dart
import 'dart:io';

import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;
  set messages(List<Map<String, dynamic>> messages) {
    _messages = messages;
    notifyListeners();
  }

  void _addMessage(Map<String, dynamic> message) {
    _messages.add(message);
    notifyListeners();
  }

  get addMessage => _addMessage;

  void _addMediaMessage(File media) {
    _messages.add({'media': media});
    notifyListeners();
  }

  get addMediaMessage => _addMediaMessage;
  void _removeMessage(int index) {
    _messages.removeAt(index);
    notifyListeners();
  }

  get removeMessage => _removeMessage;

  void _clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  get clearMessages => _clearMessages;
}
