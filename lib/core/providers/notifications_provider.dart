import 'package:flutter/material.dart';

class NotificationsProvider with ChangeNotifier {
  bool _enableNotifications = false;
  bool _emailNotifications = false;
  bool _smsNotifications = false;

  bool get enableNotifications => _enableNotifications;
  bool get emailNotifications => _emailNotifications;
  bool get smsNotifications => _smsNotifications;

  void toggleEnableNotifications(bool value) {
    _enableNotifications = value;
    notifyListeners();
  }

  void toggleEmailNotifications(bool value) {
    _emailNotifications = value;
    notifyListeners();
  }

  void toggleSmsNotifications(bool value) {
    _smsNotifications = value;
    notifyListeners();
  }
}
