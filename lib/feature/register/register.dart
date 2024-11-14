import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/widgets/custom_text_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRetryController =
      TextEditingController();

  void _register() {
    // Kayıt işlemleri burada yapılacak
    // Örneğin, bir API çağrısı yapabilirsiniz
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordRetryController.text.isEmpty) {
      _showErrorSnackbar('All fields are required.');
      return;
    }

    if (_passwordController.text != _passwordRetryController.text) {
      _showErrorSnackbar('Passwords do not match.');
      return;
    }

    // Kayıt başarılı olduğunda yapılacak işlemler
    Provider.of<NavigationProvider>(context, listen: false)
        .goTargetPage(context, Routes.login);
  }

  void _showErrorSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
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
                  controller: _emailController,
                  icon: Icons.email,
                  hintText: 'Enter Your Email',
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _passwordController,
                  obscureText: true,
                  icon: Icons.lock,
                  hintText: 'Enter Your Password',
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _passwordRetryController,
                  icon: Icons.lock,
                  obscureText: true,
                  hintText: 'Enter Retry Password',
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Register'),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<NavigationProvider>(context, listen: false)
                        .goTargetPage(context, Routes.login);
                  },
                  child: const Text(
                    'Do you have an account? Login here',
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
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRetryController.dispose();
    super.dispose();
  }
}
