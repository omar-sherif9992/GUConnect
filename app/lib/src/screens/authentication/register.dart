// ignore_for_file: use_build_context_synchronously

import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/widgets/input_field.dart';
import 'package:GUConnect/src/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    super.dispose();
  }

  Future<bool> _verifyOtp(
      String enteredOtp, UserProvider userProvider, CustomUser newUser) async {
    final bool verified =
        userProvider.verifyOTP(emailController.text.trim(), enteredOtp);
    if (verified) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('otp verified.'),
        backgroundColor: Colors.green,
      ));
      final String success = await userProvider.register(newUser);
      if (success == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Register Successful'),
          backgroundColor: Colors.green,
        ));
        final CustomUser? userWithId =
            await userProvider.getUser(emailController.text.trim());
        userProvider.setUser(userWithId!);
        Navigator.of(context).pushNamed(CustomRoutes.profile);
        return true;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Wrong OTP entered, please try again.'),
        backgroundColor: Colors.red,
      ));
      return false;
    }
    return false;
  }

  void _showOtpInputDialog(UserProvider userProvider, CustomUser newUser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Enter OTP sent to your email',
            style: TextStyle(fontSize: 18),
          ), // Title can be string too
          content: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(
                  6), // Limits input to 6 characters
            ],
            decoration: const InputDecoration(
              labelText: 'OTP',
              hintText: 'e.g 123456',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0, // change this to adjust the width
                ),
              ),
            ),
          ),

          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
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
              child: const Text('Cancel'),
            ),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  final String enteredOtp = otpController.text;
                  setState(() {
                    _isLoading = true;
                  });
                  final bool flag = await _verifyOtp(enteredOtp, userProvider,
                      newUser); // Verify the entered OTP
                  setState(() {
                    _isLoading = false;
                  });
                  // Close the dialog
                  if (flag) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // size 30% of screen width
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.3, 50),
                  alignment: Alignment.center,
                ),
                child: const Text('Submit'),
              ),
          ],
        );
      },
    );
  }

  Future<void> _register(UserProvider userProvider) async {
    final CustomUser newUser = CustomUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        fullName:
            '${emailController.text.trim().split('@')[0].split('.')[0]} ${emailController.text.trim().split('@')[0].split('.')[1]}',
        userName:
            '${emailController.text.trim().split('@')[0].split('.')[0]}${emailController.text.trim().split('@')[0].split('.')[1]}');

    userProvider.sendOtpToEmail(emailController.text.trim());
    _showOtpInputDialog(userProvider, newUser);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                      final RegExp emailRegExp = RegExp(
                          r'^[a-zA-Z]+\.[a-zA-Z]+@((guc\.edu\.eg)|(student\.guc\.edu\.eg))$');
                      if (value!.isEmpty) {
                        return 'Enter your email address';
                      } else if (!emailRegExp.hasMatch(value)) {
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
                    // inputFormatters: [NoSpaceInputFormatter()]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PasswordField(
                    passwordController: passwordController,
                    hintText: 'Password',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
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
                    // inputFormatters: [NoSpaceInputFormatter()]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PasswordField(
                      passwordController: confirmPasswordController,
                      hintText: 'Confirm Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Confirm your password';
                        } else if (value != passwordController.text.trim()) {
                          return 'Passwords do not match';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        } else {
                          return null;
                        }
                      }),
                ),
                const SizedBox(height: 10),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            _isLoading = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            if (await userProvider
                                    .getUser(emailController.text.trim()) !=
                                null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Email already Registered'),
                                backgroundColor: Colors.red,
                              ));
                              return;
                            }
                            await _register(userProvider);
                          }
                        } catch (e) {
                          print(e);
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // size 30% of screen width
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.9, 50),
                        alignment: Alignment.center,
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 18), // Customize the text size if needed
                      ),
                    ),
                  )
              ],
            ),
          ),
        ));
  }
}

class NoSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Disallow spaces in the input
    if (newValue.text.contains(' ')) {
      return oldValue;
    }
    return newValue;
  }
}
