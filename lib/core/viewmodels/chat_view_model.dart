import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seezme/core/models/chat_model.dart';

class ChatViewModel with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  List<ChatModel> _messages = [];

  List<ChatModel> get messages => _messages;

  Future<void> fetchMessages() async {
    final snapshot =
        await _firestore.collection('chats').orderBy('createdAt').get();
    _messages = snapshot.docs
        .map((doc) => ChatModel.fromFirestore(doc.data()))
        .toList();
    notifyListeners();
  }

  Future<void> sendMessage(ChatModel chat) async {
    await _firestore.collection('chats').add(chat.toFirestore());
    fetchMessages();
  }

  Future<void> deleteMessage(String messageId) async {
    await _firestore.collection('chats').doc(messageId).delete();
    fetchMessages();
  }
}
