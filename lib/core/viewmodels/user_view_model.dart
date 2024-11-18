import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seezme/core/models/user_model.dart';

class UserViewModel with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  //get user from firestore
  Future<void> fetchUsers() async {
    final snapshot = await _firestore.collection('users').get();
    _users = snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc.data()))
        .toList();
    notifyListeners();
  }

  //update user status
  Future<void> updateUserStatus(String userId, String status) async {
    await _firestore.collection('users').doc(userId).update({'status': status});
    notifyListeners();
  }
}
