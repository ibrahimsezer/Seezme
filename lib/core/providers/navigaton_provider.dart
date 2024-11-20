import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seezme/core/services/auth_service.dart';
import 'package:seezme/feature/login/login.dart';

class NavigationProvider with ChangeNotifier {
  void _goTargetPage(BuildContext context, String target) {
    Navigator.of(context).pushNamed(target);
  }

  get goTargetPage => _goTargetPage;

  Future<void> _logoutAndGoToLoginPage(BuildContext context) async {
    AuthService().signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  get logoutAndGoToLoginPage => _logoutAndGoToLoginPage;
}
