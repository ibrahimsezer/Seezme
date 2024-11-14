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
}

class Titles {
  static const String mainTitle = 'Seezme';
  static const String login = 'Login';
  static const String quit = 'Quit';
  static const String register = 'Register';
  static const String profile = 'Profile';
  static const String chatScreen = 'Chat Screen';
  static const String settings = 'Settings';
  static const String webrtc = 'WebRTC';
  static const String notifications = "Notifications";
}

class Assets {
  static const String logoTransparent = 'lib\\assets\\logotransparent2.png';
  static const String profileImage = 'https://example.com/profile_image_url';
}

String defaultFontFamily = "Roboto";
Color lightColor = const Color(0xFFFFFFFF);
Color txtBgColor = const Color(0xFF282629);
Color buttonColorDark = const Color(0xFF282629);
Color buttonBorderColorDark = const Color(0xFF2E2B30);
TextStyle errorTextStyle = TextStyle(
  fontFamily: defaultFontFamily,
  color: Colors.red,
  fontSize: 12.0,
  fontWeight: FontWeight.w200,
);

ThemeData defaultTheme = ThemeData(
  colorScheme: const ColorScheme(
    primary: Color(0xFFFFFFFF),
    secondary: Color(0xFF252128),
    surface: Color(0xFF252128),
    error: Color(0xFF252128),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF252128),
    onSurface: Color(0xFFFFFFFF),
    onError: Color(0xFF252128),
    brightness: Brightness.dark,
  ),
  primaryColor: const Color(0xFF252128),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF252128)),
  )),
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontFamily: defaultFontFamily),
    bodyMedium: TextStyle(fontFamily: defaultFontFamily),
    displayLarge: TextStyle(fontFamily: defaultFontFamily),
    displayMedium: TextStyle(fontFamily: defaultFontFamily),
    displaySmall: TextStyle(fontFamily: defaultFontFamily),
    headlineMedium: TextStyle(fontFamily: defaultFontFamily),
    headlineSmall: TextStyle(fontFamily: defaultFontFamily),
    titleLarge: TextStyle(fontFamily: defaultFontFamily),
    titleMedium: TextStyle(fontFamily: defaultFontFamily),
    titleSmall: TextStyle(fontFamily: defaultFontFamily),
    bodySmall: TextStyle(fontFamily: defaultFontFamily),
    labelLarge: TextStyle(fontFamily: defaultFontFamily),
    labelSmall: TextStyle(fontFamily: defaultFontFamily),
    headlineLarge: TextStyle(fontFamily: defaultFontFamily),
    labelMedium: TextStyle(fontFamily: defaultFontFamily),
  ),
);
