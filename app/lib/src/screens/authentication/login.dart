import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Login',
        isAuthenticated: false,
      ),
    );
  }
}
