import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
