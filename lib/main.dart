import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/feature/chat_screen.dart';
import 'package:seezme/core/providers/message_provider.dart';
import 'package:seezme/feature/login/login_page.dart';
import 'package:seezme/feature/profile/profile.dart';
import 'package:seezme/feature/settings/settings.dart';
import 'package:seezme/core/utility/constans/const.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeezMe',
      theme: defaultTheme,
      home: const LoginPage(),
      routes: {
        '/chat_screen': (context) => const ChatScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
