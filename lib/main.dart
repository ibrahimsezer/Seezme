import 'package:flutter/material.dart';
import 'package:seezme/chat_screen.dart';
import 'package:seezme/profile.dart';
import 'package:seezme/settings.dart';
import 'package:seezme/utils/const.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeezMe',
      theme: defaultTheme,
      home: const ChatScreen(),
      routes: {
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
