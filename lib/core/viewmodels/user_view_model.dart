import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seezme/core/models/user_model.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class UserViewModel with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _usersSubscription;

  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;

  String _status = Status.statusOffline;
  String get status => _status;

  @override
  void dispose() {
    _usersSubscription?.cancel();
    super.dispose();
  }

  // Replace fetchUsers with listenToUsers
  void listenToUsers() {
    _usersSubscription?.cancel();

    _usersSubscription = _firestore
        .collection('users')
        .orderBy('username')
        .snapshots()
        .listen((snapshot) {
      _users = snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc.data()))
          .toList();
      notifyListeners();
    }, onError: (error) {
      print('Error listening to users: $error');
    });
  }

  Future<void> updateUserStatus(String userId, String newStatus) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'status': newStatus,
        'lastSeen': FieldValue.serverTimestamp(),
      });
      _status = newStatus;
      notifyListeners();
    } catch (e) {
      print('Error updating user status: $e');
    }
  }

  // Add method to check and update inactive users
  Future<void> checkInactiveUsers() async {
    try {
      final now = DateTime.now();
      final threshold = now.subtract(Duration(minutes: 5));

      final snapshot = await _firestore
          .collection('users')
          .where('status', isNotEqualTo: Status.statusOffline)
          .get();

      WriteBatch batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        final lastSeen = (doc.data()['lastSeen'] as Timestamp?)?.toDate();
        if (lastSeen != null && lastSeen.isBefore(threshold)) {
          batch.update(doc.reference, {
            'status': Status.statusOffline,
            'lastSeen': FieldValue.serverTimestamp(),
          });
        }
      }

      await batch.commit();
    } catch (e) {
      print('Error checking inactive users: $e');
    }
  }

  Future<void> updateStatus(String newStatus) async {
    _status = newStatus;
    notifyListeners();
  }
}
