import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/providers/notifications_provider.dart';
import 'package:seezme/core/providers/theme_provider.dart';
import 'package:seezme/core/utility/splash_screen.dart';
import 'package:seezme/core/viewmodels/chat_view_model.dart';
import 'package:seezme/core/viewmodels/user_view_model.dart';
import 'package:seezme/feature/chat_screen.dart';
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
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MyApp(initialRoute: Routes.splashScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        Routes.splashScreen: (context) => SplashScreen(),
      },
    );
  }
}
