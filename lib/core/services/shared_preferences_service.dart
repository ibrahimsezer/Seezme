import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  //todo rework SharedPreferencesService
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';

  Future<bool> isLoggedIn() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return true;
      } else {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getBool(_isLoggedInKey) ?? false;
      }
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  Future<void> setLoggedIn(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, value);
    } catch (e) {
      print('Error setting shared preferences: $e');
    }
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }
}
