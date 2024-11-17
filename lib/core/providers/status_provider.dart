import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class StatusProvider with ChangeNotifier {
  String _status = Status.statusAvailable;
  get status => _status;

  Future<void> updateUserStatusInFirestore(
      String userId, String newStatus) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'status': newStatus,
    });
  }

  void updateStatus(String newStatus, String userId) {
    log("message: $newStatus, $userId");
    _status = newStatus;
    notifyListeners();
    updateUserStatusInFirestore(userId, newStatus);
  }
}
