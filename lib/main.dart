import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/providers/notifications_provider.dart';
import 'package:seezme/core/providers/status_provider.dart';
import 'package:seezme/core/providers/theme_provider.dart';
import 'package:seezme/core/services/shared_preferences_service.dart';
import 'package:seezme/feature/chat_screen.dart';
import 'package:seezme/core/providers/message_provider.dart';
import 'package:seezme/feature/connection/webrtc.dart';
import 'package:seezme/feature/login/login.dart';
import 'package:seezme/feature/profile/profile.dart';
import 'package:seezme/feature/register/register.dart';
import 'package:seezme/feature/settings/notifications.dart';
import 'package:seezme/feature/settings/privacy.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/feature/settings/theme_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedPreferencesService = SharedPreferencesService();
  final isLoggedIn = await sharedPreferencesService.isLoggedIn();
  print('Is Logged In: $isLoggedIn');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MessageProvider(),
        ),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => StatusProvider()),
      ],
      child: MyApp(initialRoute: isLoggedIn ? Routes.login : Routes.register),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: Titles.mainTitle,
        theme: defaultTheme, // todo rework theme
        darkTheme: ThemeData.dark(),
        themeMode: Provider.of<ThemeProvider>(context).currentTheme,
        initialRoute: initialRoute,
        routes: {
          Routes.register: (context) => const RegisterPage(),
          Routes.login: (context) => const LoginPage(),
          Routes.profile: (context) => const ProfileScreen(),
          Routes.chatScreen: (context) => const ChatScreen(),
          Routes.webrtc: (context) => VideoCallScreen(),
          Routes.notifications: (context) => NotificationsPage(),
          Routes.theme: (context) => ThemeSettingsPage(),
          Routes.privacy: (context) => PrivacyPage(),
        },
      ),
    );
  }
}
