import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seezme/core/models/chat_model.dart';

class ChatViewModel with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  List<ChatModel> _messages = [];
  List<ChatModel> _allChatList = [];

  List<ChatModel> get messages => _messages;
  List<ChatModel> get allChatList => _allChatList;

  void listenToMessages() {
    _firestore
        .collection('chats')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snapshot) {
      _messages = snapshot.docs
          .map((doc) => ChatModel.fromFirestore(doc.data()))
          .toList();
      notifyListeners();
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
    await _firestore.collection('chats').add(chat.toFirestore());
    fetchMessages();
  }

  Future<void> deleteMessage(String messageId) async {
    await _firestore.collection('chats').doc(messageId).delete();
    fetchMessages();
  }

  Future<void> deleteAllMessage() async {
    await _firestore.collection('chats').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    fetchMessages();
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
}
