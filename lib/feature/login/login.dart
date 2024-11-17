import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/services/shared_preferences_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/widgets/authentication_button_widget.dart';
import 'package:seezme/widgets/custom_textfield_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  Future<void> _login() async {
    final usernameOrEmail = _usernameController.text;
    final password = _passwordController.text;

    try {
      // Query for username
      final usernameQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: usernameOrEmail)
          .where('password', isEqualTo: password)
          .get();

      // Query for email
      final emailQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: usernameOrEmail)
          .where('password', isEqualTo: password)
          .get();

      if (usernameQuerySnapshot.docs.isNotEmpty ||
          emailQuerySnapshot.docs.isNotEmpty) {
        // Kullanıcı adını al
        final userDoc = usernameQuerySnapshot.docs.isNotEmpty
            ? usernameQuerySnapshot.docs.first
            : emailQuerySnapshot.docs.first;
        final username = userDoc['username'];
        final email = userDoc['email'];

        // Save login status and username
        await _sharedPreferencesService.setLoggedIn(true);
        await _sharedPreferencesService.setUsername(username);
        await _sharedPreferencesService.setEmail(email);

        // Navigate to chat screen
        Navigator.pushReplacementNamed(context, Routes.chatScreen);
      } else {
        _showErrorSnackbar('Invalid username/email or password');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to login. Please try again.');
      print(e);
    }
  }

//todo add google sign in
  // Future<void> _handleGoogleSignIn() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser != null) {
  //       final GoogleSignInAuthentication googleAuth =
  //           await googleUser.authentication;
  //       final String? idToken = googleAuth.idToken;

  //       // Save login status
  //       await _sharedPreferencesService.setLoggedIn(true);
  //       // Navigate to chat screen
  //       Provider.of<NavigationProvider>(context, listen: false)
  //           .goTargetPage(context, Routes.chatScreen);
  //     } else {
  //       _showErrorSnackbar('Google Sign-In failed. Please try again.');
  //     }
  //   } catch (error) {
  //     _showErrorSnackbar('Google Sign-In failed. Please try again.');
  //     print(error);
  //   }
  // }

  void _showErrorSnackbar(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      content: Text(
        message,
        style: errorTextStyle,
      ),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  height: 200,
                  width: 200,
                  image: AssetImage(Assets.logoTransparent),
                  fit: BoxFit.contain,
                ),
                CustomTextField(
                  controller: _usernameController,
                  icon: Icons.person,
                  hintText: 'Username or Email',
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  icon: Icons.lock,
                  controller: _passwordController,
                  obscureText: true,
                  hintText: 'Password',
                ),
                const SizedBox(height: 16.0),
                AuthenticationButtonWidget(
                  function: _login,
                  authenticationType: LoginType.email,
                ),
                const SizedBox(height: 16.0),
                //todo not working
                // AuthenticationButtonWidget(
                //   function: _handleGoogleSignIn,
                //   authenticationType: LoginType.google,
                // ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    Provider.of<NavigationProvider>(context, listen: false)
                        .goTargetPage(context, Routes.register);
                  },
                  child: const Text(
                    'Don\'t have an account? Register here',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
