import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/utility/constans/constants.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _registerWithEmail() async {
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

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save user info to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text,
        'password': _passwordController.text,
        'username': _emailController.text.split('@').first,
        'createdAt': Timestamp.now(),
      });

      // Navigate to login page
      Provider.of<NavigationProvider>(context, listen: false)
          .goTargetPage(context, Routes.login);
    } catch (e) {
      _showErrorSnackbar(
          'Sign up with a real email. (Password must be minimum 6 characters)');
      print(e);
    }
  }
  //todo added register with google

  void _showErrorSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
