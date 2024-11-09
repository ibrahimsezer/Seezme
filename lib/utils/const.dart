import 'package:flutter/material.dart';

String defaultFontFamily = "Roboto";
Color lightColor = const Color(0xFF2B272F);
Color txtBgColor = const Color(0xFF282629);

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
