import 'package:flutter/material.dart';
import 'package:seezme/feature/login/login.dart';

class NavigationProvider with ChangeNotifier {
  void _goTargetPage(BuildContext context, String target) {
    Navigator.of(context).pushNamed(target);
  }

  get goTargetPage => _goTargetPage;

  void _logoutAndGoToLoginPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  get logoutAndGoToLoginPage => _logoutAndGoToLoginPage;
}
