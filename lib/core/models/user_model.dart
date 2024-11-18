import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final String status;
  final DateTime createdAt;

  UserModel({
    required this.email,
    required this.username,
    required this.status,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      status: data['status'] ?? 'offline',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
