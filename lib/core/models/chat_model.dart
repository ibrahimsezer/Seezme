import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String sender;
  final String message;
  final String type;
  final Timestamp createdAt;

  ChatModel({
    required this.sender,
    required this.message,
    required this.type,
    required this.createdAt,
  });

  factory ChatModel.fromFirestore(Map<String, dynamic> data) {
    return ChatModel(
      sender: data['sender'] ?? '',
      message: data['message'] ?? '',
      type: data['type'] ?? 'text',
      createdAt: (data['createdAt'] as Timestamp),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sender': sender,
      'message': message,
      'type': type,
      'createdAt': createdAt,
    };
  }
}
