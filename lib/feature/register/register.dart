import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/services/auth_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/utility/helper_function.dart';
import 'package:seezme/widgets/authentication_button_widget.dart';
import 'package:seezme/widgets/custom_textfield_widget.dart';

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
  final AuthService _authService = AuthService();

  Future<void> _registerWithEmail() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordRetryController.text.isEmpty) {
      showErrorSnackbar('All fields are required.', context);
      return;
    }

    if (_passwordController.text != _passwordRetryController.text) {
      showErrorSnackbar('Passwords do not match.', context);
      return;
    }

    try {
      _authService.register(_emailController.text, _passwordController.text);

      // Navigate to login page
      Provider.of<NavigationProvider>(context, listen: false)
          .goTargetPage(context, Routes.login);
    } catch (e) {
      showErrorSnackbar(
          'Sign up with a real email. (Password must be minimum 6 characters)',
          context);
      print(e);
    }
  }
  //todo added register with google

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRetryController.dispose();
    super.dispose();
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
                AuthenticationButtonWidget(
                    function: _registerWithEmail,
                    authenticationType: RegisterType.email),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Provider.of<NavigationProvider>(context, listen: false)
                        .goTargetPage(context, Routes.login);
                  },
                  child: const Text(
                    'Do you have an account? Login here',
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
}
