import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seezme/core/providers/navigaton_provider.dart';
import 'package:seezme/core/services/auth_service.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/utility/helper_function.dart';
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
  final AuthService _auth = AuthService();

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
        final userDoc = usernameQuerySnapshot.docs.isNotEmpty
            ? usernameQuerySnapshot.docs.first
            : emailQuerySnapshot.docs.first;
        final email = userDoc['email'];

        // Save login status and username
        await _auth.signIn(email, password);
        // Navigate to chat screen
        Navigator.pushReplacementNamed(context, Routes.chatScreen);
      } else {
        showErrorSnackbar('Invalid username/email or password', context);
        showErrorSnackbar(
            'Try this \nUsername : user#1\nEmail: user@mail.com', context);
      }
    } catch (e) {
      showErrorSnackbar('Failed to login. Please try again.', context);
      print(e);
    }
  }

//todo add google sign in

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: PaddingSize.paddingStandartSize,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  width: 200,
                  image: AssetImage(Assets.logoTransparent),
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 64),
                Text("Sign In",
                    style: TextStyle(
                      color: ConstColors.orangeWeb,
                      fontSize: FontSize.bigTitleFontSize,
                    )),
                SizedBox(height: 16),

                CustomTextField(
                  title: "Email or Username",
                  controller: _usernameController,
                  icon: Icons.person,
                  hintText: 'Username or Email',
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  title: "Password",
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
                      color: ConstColors.orangeWeb,
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
