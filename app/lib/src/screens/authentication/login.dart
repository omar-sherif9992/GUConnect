import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/GUConnect-horizontal-Logo.png',
            height: 160,
            width: 160,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start of the Column
          children: [
            // Text on the left with subtext under it
            const Padding(
              padding: EdgeInsets.only(left:18.0,top: 8,bottom: 8,right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stay Engaged, Stay Connected',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // Add some space between main text and subtext
                  Text(
                    'The best way to get the most out of our app is to participate actively.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              constraints: const BoxConstraints.expand(height: 50),
              child: const TabBar(
                tabs: [
                  Tab(text: 'Login'),
                  Tab(text: 'Create Account'),
                ],
                indicatorWeight: 3.0,
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  LoginForm(),
                  RegisterForm(),
                ],
              ),
            ),
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
    return Container();
  }
}