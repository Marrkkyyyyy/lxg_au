import 'package:flutter/material.dart';
import 'package:lxg_au/constant/app_constant.dart';
import '../../../services/lxg_api_service.dart';
import '../../../main.dart';
import '../widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String error = '';

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      setState(() => error = 'Please enter a valid email.');
      return;
    }
    if (password.isEmpty) {
      setState(() => error = 'Password cannot be empty.');
      return;
    }

    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      // Perform complete login process
      final loginResponse = await ApiService.performLogin(email, password);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(initialUser: loginResponse.user, initialMembership: loginResponse.membership),
        ),
      );
    } catch (e) {
      print('Login Error: $e');
      setState(() => error = 'Login failed. Please check credentials.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF000000),
                Color(0xFF1a1a1a),
                Color(0xFF0a0a0a),
              ],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFEC404).withOpacity(0.2),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AppConstant.logo,
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 48),
                    LoginFormWidget(
                      emailController: emailController,
                      passwordController: passwordController,
                      isLoading: isLoading,
                      error: error,
                      onLogin: login,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
