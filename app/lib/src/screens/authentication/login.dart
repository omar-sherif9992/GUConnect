import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Login',),
                Tab(text: 'Create Account'),
              ],
            ),
            title: Image.asset('assets/images/GUConnect-horizontal-Logo.png', height: 160, width: 160),
          ),
          body: const TabBarView(
            children: [
              LoginForm(),
              RegisterForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
              labelText: 'Email Address',
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              // Handle login
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
              labelText: 'Email Address',
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),          
          TextField(
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
            ),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              // Handle Register
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
