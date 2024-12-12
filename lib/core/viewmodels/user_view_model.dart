import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seezme/core/models/user_model.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class UserViewModel with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;

  String _status = Status.statusOffline;
  String get status => _status;

  Future<void> refreshStatus() async {
    _status;
    notifyListeners();
  }

  Future<void> updateStatus(String newStatus) async {
    _status = newStatus;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    final snapshot =
        await _firestore.collection('users').orderBy('username').get();
    _users = snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc.data()))
        .toList();
    notifyListeners();
  }

  //update user status
  Future<void> updateUserStatus(String userId, String newStatus) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'status': newStatus,
    });
    updateStatus(newStatus);
  }
}
