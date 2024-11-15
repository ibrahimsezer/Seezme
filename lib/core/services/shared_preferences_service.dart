import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  //todo rework SharedPreferencesService
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';

  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Error getting shared preferences: $e');
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

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }
}
