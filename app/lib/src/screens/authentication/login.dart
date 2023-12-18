import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/screens/authentication/register.dart';
import 'package:GUConnect/src/widgets/input_field.dart';
import 'package:GUConnect/src/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
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
  bool _isLoading = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(UserProvider userProvider) async {
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
        if (user != null) {
          userProvider.setUser(user);
        }

        if (context.mounted) {
          /*   if (emailController.text.trim().contains('@gucconnect.com')) {
            Navigator.pushReplacementNamed(context, CustomRoutes.profile , arguments: {'user': user});
          } else {
            Navigator.pushReplacementNamed(context, CustomRoutes.profile,
                arguments: {'user': user});
          } */
          Navigator.pushNamed(context, CustomRoutes.profile,
              arguments: {'user': user});
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
      child: Scaffold(
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
                    EdgeInsets.only(left: 18.0, top: 14, bottom: 14, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stay Engaged, Stay Connected',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'poppins',
                          letterSpacing: 1.1),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                        height:
                            16), // Add some space between main text and subtext
                    Text(
                      'The best way to get the most out of our app is to participate actively.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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
                    SingleChildScrollView(
                        child: Padding(
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
                                    !value.contains('@student.guc.edu.eg') &&
                                    !value.contains('@gucconnect.com')) {
                                  return 'Enter a valid GUC email address';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PasswordField(
                              passwordController: passwordController,
                              hintText: 'password',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter your password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (_isLoading)
                            const CircularProgressIndicator()
                          else
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await _login(userProvider);
                                    setState(() {
                                      _isLoading = false;
                                    });
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
