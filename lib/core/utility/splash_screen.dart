import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/services/auth_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/viewmodels/user_view_model.dart';
import 'package:seezme/feature/chat_screen.dart';
import 'package:seezme/feature/login/login.dart';

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
    final _authService = AuthService();
    final isLoggedIn = await _authService.isLoggedIn();

    await Future.delayed(Duration(seconds: 1));
    if (isLoggedIn) {
      _authService
          .listenToStatus(_authService.auth.currentUser!.uid)
          .listen((status) {
        Provider.of<UserViewModel>(context, listen: false)
            .updateStatus(status!);
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
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
