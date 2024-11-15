import 'package:flutter/material.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class StatusProvider with ChangeNotifier {
  String _status = Status.statusAvailable;
  get status => _status;

  void updateStatus(String newStatus) {
    _status = newStatus;
    notifyListeners();
  }
}
