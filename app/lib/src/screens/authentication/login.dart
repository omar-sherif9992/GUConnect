import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/screens/authentication/register.dart';
import 'package:GUConnect/src/widgets/input_field.dart';
import 'package:GUConnect/src/widgets/password_field.dart';
import 'package:GUConnect/themes/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:GUConnect/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  _login(UserProvider userProvider) async {
    final bool success =
        await userProvider.login(emailController.text, passwordController.text);
    if (success) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful.'),
            backgroundColor: Colors.green,
          ),
        );
        final CustomUser? user =
            await userProvider.getUser(emailController.text);
        if(user != null){
          userProvider.setUser(user);}
     
        if (context.mounted) {
          if(emailController.text.trim().contains('@gucconnect.com')){
            Navigator.popAndPushNamed(context, CustomRoutes.admin);
          }else{
            Navigator.popAndPushNamed(context, CustomRoutes.profile);
          }

        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Form(
      key: _formKey,
      child: 
      Scaffold(
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
              // login
              
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
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InputField(
                              controller: emailController,
                              label: 'Email Address',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter your email address';
                                } else if (!value.contains('@guc.edu.eg') &&
                                    !value.contains('@student.guc.edu.eg')&& !value.contains('@gucconnect.com')) {
                                  return 'Enter a valid GUC email address';
                                } else {
                                  return null;
                                }
                              },
                              // decoration: const InputDecoration(
                              //   labelText: 'Email Address',
                              //   hintText: 'Sample@guc.edu.eg',
                              //   border: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //       width: 2.0, // change this to adjust the width
                              //     ),
                              //   ),
                              // ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PasswordField(
                              passwordController: passwordController,
                              hintText: '********',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter your password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                } else {
                                  return null;
                                }
                              },
                              // decoration: const InputDecoration(
                              //   labelText: 'Password',
                              //   hintText: '********',
                              //   border: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //       width: 2.0, // change this to adjust the width
                              //     ),
                              //   ),
                              // ),
                              // obscureText: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await _login(userProvider);
                                  print('/////////////////////////////////////////////');
                                  print(userProvider.user);
                                  print('/////////////////////////////////////////////');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // size 30% of screen width
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.9,
                                    50),
                                alignment: Alignment.center,
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize:
                                        18), // Customize the text size if needed
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                    const RegisterScreen(),
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
