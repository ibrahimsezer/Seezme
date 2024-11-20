import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final String status;
  final Timestamp createdAt;
  final String password;
  final String uid;

  UserModel({
    required this.email,
    required this.username,
    required this.status,
    required this.createdAt,
    required this.password,
    required this.uid,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      status: data['status'] ?? 'offline',
      createdAt: (data['createdAt'] as Timestamp),
      password: data['password'] ?? '',
      uid: data['uid'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'status': status,
      'createdAt': createdAt,
      'password': password,
      'uid': uid,
    };
  }
}
