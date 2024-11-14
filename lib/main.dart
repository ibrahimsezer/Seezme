import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/feature/chat_screen.dart';
import 'package:seezme/core/providers/message_provider.dart';
import 'package:seezme/feature/connection/webrtc.dart';
import 'package:seezme/feature/login/login.dart';
import 'package:seezme/feature/profile/profile.dart';
import 'package:seezme/feature/register/register.dart';
import 'package:seezme/feature/settings/settings.dart';
import 'package:seezme/core/utility/constans/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MessageProvider(),
        ),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
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
      home: SettingsScreen(),
      routes: {
        Routes.register: (context) => const RegisterPage(),
        Routes.login: (context) => const LoginPage(),
        Routes.settings: (context) => const SettingsScreen(),
        Routes.profile: (context) => const ProfileScreen(),
        Routes.chatScreen: (context) => const ChatScreen(),
        Routes.webrtc: (context) => VideoCallScreen(),
      },
    );
  }
}
