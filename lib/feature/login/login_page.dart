import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seezme/core/utility/constans/const.dart';
import 'package:seezme/widgets/custom_text_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String logoPath = 'lib\\assets\\logotransparent2.png';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleGoogleSignIn() async {
    try {
      await _googleSignIn.signIn();
      Navigator.of(context).pushNamed('/chat_screen');
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
    Navigator.of(context).pushNamed('/chat_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: 200,
                width: 200,
                image: AssetImage(logoPath),
                fit: BoxFit.contain,
              ),
              CustomTextField(
                controller: _usernameController,
                icon: Icons.person,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                icon: Icons.lock,
                controller: _passwordController,
                obscureText: true,
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
            ],
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
