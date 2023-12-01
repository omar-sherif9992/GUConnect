import 'package:GUConnect/src/screens/authentication/register.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/themes/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.lightTheme,
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
            crossAxisAlignment: CrossAxisAlignment
                .start, // Aligns children to the start of the Column
            children: [
              // Text on the left with subtext under it
              const Padding(
                padding:
                    EdgeInsets.only(left: 18.0, top: 8, bottom: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stay Engaged, Stay Connected',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                        height:
                            8), // Add some space between main text and subtext
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
                    RegisterScreen(),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'Sample@guc.edu.eg',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0, // change this to adjust the width
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '********',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0, // change this to adjust the width
                  ),
                ),
              ),
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              onPressed: () {
                UserProvider userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                userProvider.login('email', 'password');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // size 30% of screen width
                minimumSize: Size(MediaQuery.of(context).size.width * 0.3, 50),
                alignment: Alignment.center,
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                    fontSize: 18), // Customize the text size if needed
              ),
            ),
          )
        ],
      ),
    );
  }
}
