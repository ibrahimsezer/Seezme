import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/services/shared_preferences_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  _navigateToNextPage() async {
    final sharedPreferencesService = SharedPreferencesService();
    final isLoggedIn = await sharedPreferencesService.isLoggedIn();
    await Future.delayed(Duration(seconds: 2));
    if (isLoggedIn) {
      Provider.of<NavigationProvider>(context, listen: false)
          .goTargetPage(context, Routes.chatScreen);
    } else {
      Provider.of<NavigationProvider>(context, listen: false)
          .goTargetPage(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          width: sizeWidth,
          height: sizeHeight,
          child: Image.asset(
            Assets.logo_9_16,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
