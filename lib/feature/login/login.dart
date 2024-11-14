import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/widgets/custom_text_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleGoogleSignIn() async {
    try {
      await _googleSignIn.signIn();
      Provider.of<NavigationProvider>(context, listen: false)
          .goTargetPage(context, Routes.chatScreen);
    } catch (error) {
      _showErrorSnackbar('Google Sign-In failed. Please try again.');
      print(error);
    }
  }

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

  void _login() {
    // Kullanıcı adı ve şifre ile giriş işlemleri burada yapılacak
    // Örneğin, bir API çağrısı yapabilirsiniz
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackbar('Username and password cannot be empty.');
      return;
    }
    Provider.of<NavigationProvider>(context, listen: false)
        .goTargetPage(context, Routes.chatScreen);
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
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _handleGoogleSignIn,
                  child: const Text('Login with Google'),
                ),
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
                      decoration: TextDecoration.underline,
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
