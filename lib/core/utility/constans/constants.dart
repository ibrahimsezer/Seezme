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
  static const String splashScreen = "/splash_screen";
  static const String uitest = "/uitest";
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
  static const String activeUsers = "Active Users";
}

class Assets {
  static const String logoTransparent =
      'lib/assets/appimage/logotransparent2.png';
  static const String logoSquare = 'lib/assets/appimage/logosquare.jpeg';
  static const String profileImage =
      'lib/assets/appimage/default_user_profile_photo.jpeg';
  static const String profileImage2 =
      'lib/assets/appimage/default_user_profile_photo_2.jpeg';
  static const String profileImage3 =
      'lib/assets/appimage/default_user_profile_photo_3.jpeg';
  static const String profileImage4 =
      'lib/assets/appimage/default_user_profile_photo_4.jpeg';
  static const String profileImage5 =
      'lib/assets/appimage/default_user_profile_photo_5.jpeg';
  static const String profileImage6 =
      'lib/assets/appimage/default_user_profile_photo_6.jpeg';
  static const String profileImage7 =
      'lib/assets/appimage/default_user_profile_photo_7.jpeg';
  static const String profileImage8 =
      'lib/assets/appimage/default_user_profile_photo_8.jpeg';
  static const String profileImage9 =
      'lib/assets/appimage/default_user_profile_photo_9.jpeg';
  static const String profileImage10 =
      'lib/assets/appimage/default_user_profile_photo_10.jpeg';
  static const String profileImage11 =
      'lib/assets/appimage/default_user_profile_photo_11.jpeg';
  static const String profileImage12 =
      'lib/assets/appimage/default_user_profile_photo_12.jpeg';

  static const String logo_9_16 = "lib/assets/appimage/logo.jpg";
}

class Status {
  static const String statusAvailable = 'Available';
  static const String statusIdle = 'Idle';
  static const String statusBusy = 'Busy';
  static const String statusOffline = 'Offline';
}

class LoginType {
  static const String google = 'Sign In with Google';
  static const String email = 'Sign In';
}

class RegisterType {
  static const String google = 'Sign Up With Google';
  static const String email = 'Sign Up';
}

class FontSize {
  static const double dateFontSize = 10.0;
  static const double usernameFontSize = 16.0;
  static const double textFontSize = 16.0;
  static const double buttonTextFontSize = 16.0;
  static const double statusFontSize = 12.0;
  static const double emailFontSize = 12.0;
  static const double titleFontSize = 12.0;
  static const double bigTitleFontSize = 24.0;
}

class PaddingSize {
  static const EdgeInsets paddingLargeSize = EdgeInsets.all(32);
  static const EdgeInsets paddingMediumSize = EdgeInsets.all(24);
  static const EdgeInsets paddingStandartSize = EdgeInsets.all(16);
  static const EdgeInsets paddingSmallSize = EdgeInsets.all(8);
}

class ConstColors {
  static const Color primaryColor = Color(0xFF1B1311);
  static const Color secondaryColor = Color(0xFFFEAE03);
  static const Color surfaceColor = Color(0xFF1B1311);
  static const Color errorColor = Color(0xFFFFFFFF);
  static const Color onPrimaryColor = Color(0xFFFFFFFF);
  static const Color onSecondaryColor = Color(0xFF1B1311);
  static const Color onSurfaceColor = Color(0xFFFFFFFF);
  static const Color onErrorColor = Color(0xFFFF3300);

  static const Color foregroundColor = Color(0xFF1B1311);
  static const Color backgroundColor = Color(0xFFFEAE03);
  static const Color fontColor = Color(0xFF1B1311);

  static const Color dateColor = Color(0xFF1B1311);

  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color greyColor = Color(0xFF9E9E9E);
  static const Color blueDodger = Color(0xFF078BFE);
  static const Color redImperial = Color(0xFFFC333C);
  static const Color orangeWeb = Color(0xFFFEAE03);
  static const Color blackLicorice = Color(0xFF1B1311);
  static const Color blackLicoriceDark = Color(0xFF191210);
  static const Color green = Color(0xFF10B90D);
}

String defaultFontFamily = "Zona Pro Family";
Color defaultTextBackgroundColor = const Color(0xFFFEAE03);
Color defaultButtonColorDark = const Color(0xFFFEAE03);
Color defaultButtonBorderColorDark = const Color(0xFFFEAE03);
TextStyle errorTextStyle = TextStyle(
  fontFamily: defaultFontFamily,
  color: Colors.red,
  fontSize: 12.0,
  fontWeight: FontWeight.w200,
);

ThemeData defaultTheme = ThemeData(
  colorScheme: const ColorScheme(
    primary: ConstColors.primaryColor, // Ana renk
    secondary: ConstColors.secondaryColor, // İkincil renk
    surface: ConstColors.surfaceColor, // Yüzey rengi
    error: ConstColors.errorColor, // Hata rengi
    onPrimary: ConstColors.onPrimaryColor, // Ana renk üzerindeki yazı rengi
    onSecondary:
        ConstColors.onSecondaryColor, // İkincil renk üzerindeki yazı rengi
    onSurface: ConstColors.onSurfaceColor, // Yüzey rengi üzerindeki yazı rengi
    onError: ConstColors.onErrorColor, // Hata rengi üzerindeki yazı rengi
    brightness: Brightness.dark, // Tema parlaklığı
  ),
  primaryColor: ConstColors.primaryColor, // Ana renk
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor:
          WidgetStateProperty.all<Color>(ConstColors.foregroundColor),
      backgroundColor: WidgetStateProperty.all<Color>(
          ConstColors.backgroundColor), // Buton arka plan rengi
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
        fontFamily: defaultFontFamily,
        color: ConstColors.fontColor), // Büyük metin rengi
    bodyMedium: TextStyle(
        fontFamily: defaultFontFamily,
        color: ConstColors.fontColor), // Orta metin rengi
    displayLarge: TextStyle(
        fontFamily: defaultFontFamily,
        color: ConstColors.fontColor), // Büyük başlık rengi
  ),
);
