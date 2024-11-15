import 'package:flutter/material.dart';

class Routes {
  static const String login = '/login';
  static const String quit = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String chatScreen = '/chat_screen';
  static const String settings = '/settings';
  static const String webrtc = '/webrtc';
  static const String notifications = "/notifications";
  static const String privacy = "/privacy";
  static const String theme = "/theme_settings";
}

class Titles {
  static const String mainTitle = 'Seezme';
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String register = 'Register';
  static const String profile = 'Profile';
  static const String chatScreen = 'Chat Screen';
  static const String settings = 'Settings';
  static const String webrtc = 'WebRTC';
  static const String notifications = "Notifications";
  static const String privacy = "Privacy";
  static const String theme = "Theme";
}

class Assets {
  static const String logoTransparent = 'lib/assets/logotransparent2.png';
  static const String logoSquare = 'lib/assets/logosquare.jpeg';
  static const String profileImage =
      'lib/assets/default_user_profile_photo.jpeg';
}

class Status {
  static const String statusAvailable = 'Available';
  static const String statusIdle = 'Idle';
  static const String statusBusy = 'Busy';
}

class LoginType {
  static const String google = 'Login with Google';
  static const String email = 'Login with Email';
}

class RegisterType {
  static const String google = 'Register with Google';
  static const String email = 'Register with Email';
}

String defaultFontFamily = "Roboto";
Color defaultLightColor = const Color(0xFF596275);
Color defaultTextBackgroundColor = const Color(0xFF596275);
Color defaultButtonColorDark = const Color(0xFF596275);
Color defaultButtonColorLight = const Color(0xFFFFFFFF);
Color defaultButtonBorderColorDark = const Color(0xFF596275);
TextStyle errorTextStyle = TextStyle(
  fontFamily: defaultFontFamily,
  color: Colors.red,
  fontSize: 12.0,
  fontWeight: FontWeight.w200,
);

ThemeData defaultTheme = ThemeData(
  colorScheme: const ColorScheme(
    primary: Color(0xFF303952), // Ana renk
    secondary: Color(0xFF596275), // İkincil renk
    surface: Color(0xFF303952), // Yüzey rengi
    error: Color(0xFF252128), // Hata rengi
    onPrimary: Color(0xFFFFFFFF), // Ana renk üzerindeki yazı rengi
    onSecondary: Color(0xFFFFFFFF), // İkincil renk üzerindeki yazı rengi
    onSurface: Color(0xFFFFFFFF), // Yüzey rengi üzerindeki yazı rengi
    onError: Color(0xFFFFFFFF), // Hata rengi üzerindeki yazı rengi
    brightness: Brightness.dark, // Tema parlaklığı
  ),
  primaryColor: const Color(0xFF303952), // Ana renk
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
          const Color(0xFF596275)), // Buton arka plan rengi
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
        fontFamily: defaultFontFamily,
        color: Color(0xFFFFFFFF)), // Büyük metin rengi
    bodyMedium: TextStyle(
        fontFamily: defaultFontFamily,
        color: Color(0xFFFFFFFF)), // Orta metin rengi
    displayLarge: TextStyle(
        fontFamily: defaultFontFamily,
        color: Color(0xFFFFFFFF)), // Büyük başlık rengi
  ),
);
