import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seezme/core/models/chat_model.dart';

class ChatViewModel with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  List<ChatModel> _messages = [];
  List<ChatModel> _allChatList = [];
  StreamSubscription<QuerySnapshot>? _chatSubscription;
  bool _shouldScrollToBottom = false;

  List<ChatModel> get messages => _messages;
  List<ChatModel> get allChatList => _allChatList;
  bool get shouldScrollToBottom => _shouldScrollToBottom;

  void listenToMessages() {
    _chatSubscription?.cancel();

    _chatSubscription = _firestore
        .collection('chats')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snapshot) {
      _messages = snapshot.docs
          .map((doc) => ChatModel.fromFirestore({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();

      _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      notifyListeners();
    }, onError: (error) {
      print('Error listening to messages: $error');
    });
  }

  Future<void> fetchMessages() async {
    final snapshot =
        await _firestore.collection('chats').orderBy('createdAt').get();
    _messages = snapshot.docs
        .map((doc) => ChatModel.fromFirestore(doc.data()))
        .toList();
    notifyListeners();
  }

  Future<void> sendMessage(ChatModel chat) async {
    try {
      await _firestore.collection('chats').add(chat.toFirestore());
    } catch (e) {
      print('Error sending message: $e');
      throw e;
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await _firestore.collection('chats').doc(messageId).delete();
    } catch (e) {
      print('Error deleting message: $e');
      throw e;
    }
  }

  Future<void> deleteAllMessage() async {
    try {
      WriteBatch batch = _firestore.batch();
      var snapshots = await _firestore.collection('chats').get();

      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Error deleting all messages: $e');
      throw e;
    }
  }

//------------------  All Chats ------------------
//todo create new model for all chats
  Future<void> fetchMessagesAll(String chatId) async {
    final snapshot = await _firestore
        .collection('allchats')
        .doc(chatId)
        .collection(chatId)
        .orderBy('createdAt', descending: true)
        .get();

    _allChatList = snapshot.docs
        .map((doc) => ChatModel.fromFirestore(doc.data()))
        .toList();
    notifyListeners();
  }

  Future<void> sendMessageAll(String chatId, ChatModel chat) async {
    await _firestore
        .collection('allchats')
        .doc(chatId)
        .collection(chatId)
        .add(chat.toFirestore());

    await fetchMessagesAll(chatId);
  }

  Future<void> createNewChatRoom(String chatId) async {
    final chatDoc = _firestore.collection('allchats').doc(chatId);
    await chatDoc.set({
      'createdAt': Timestamp.now(),
    });
  }

  void resetScrollFlag() {
    _shouldScrollToBottom = false;
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    super.dispose();
  }
}
