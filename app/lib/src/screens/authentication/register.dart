import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  _verifyOtp(String enteredOtp, UserProvider userProvider, String email) {
    final bool verified = userProvider.verifyOTP(email, enteredOtp);
    if (verified) {
      Fluttertoast.showToast(
        msg: 'OTP verification successful!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'OTP verification failed:',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  void _showOtpInputDialog(UserProvider userProvider, String email) {
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
              child: const Text('Cancel'),
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
            ),
            ElevatedButton(
              onPressed: () {
                final String enteredOtp = otpController.text;
                _verifyOtp(
                    enteredOtp, userProvider, email); // Verify the entered OTP
                // Close the dialog
                Navigator.pop(context);
              },
              child: const Text('Submit'),
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
            ),
          ],
        );
      },
    );
  }

  _register() async {
    final CustomUser newUser = CustomUser.register(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
    final RegExp emailRegExp = RegExp(r'^[a-zA-Z]+\.[a-zA-Z]+@((guc\.edu\.eg)|(student\.guc\.edu\.eg))$');
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if (emailRegExp.hasMatch(emailController.text)) {
      if (passwordController.text.trim().length >= 6) {
        if(passwordController.text.trim() == confirmPasswordController.text.trim()) {
        final bool success = await userProvider.register(newUser);
        if (success) {
          Fluttertoast.showToast(
            msg: 'Registration successful. Check your email for verification.',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
          );
          userProvider.sendOtpToEmail(emailController.text.trim());
          _showOtpInputDialog(userProvider, emailController.text.trim());
        } else {
          Fluttertoast.showToast(
            msg: 'Registration failed as email already exists.',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
          );
        }
        }else{
          Fluttertoast.showToast(
            msg: 'Passwords do not match.',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
          );
        }
        // final bool success = userProvider.register(newUser) as bool;
        
      } else {
        Fluttertoast.showToast(
          msg: 'Password must be at least 6 characters long.',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Invalid email address.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                hintText: 'Sample@guc.edu.eg',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0, // change this to adjust the width
                  ),
                ),
              ),
              inputFormatters: [NoSpaceInputFormatter()]
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: '********',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0, // change this to adjust the width
                  ),
                ),
              ),
              obscureText: true,
              inputFormatters: [NoSpaceInputFormatter()]
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                hintText: '********',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.0, // change this to adjust the width
                  ),
                ),
              ),
              obscureText: true,
              inputFormatters: [NoSpaceInputFormatter()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              onPressed: () {
                _register(); // Handle Register
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // size 30% of screen width
                minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
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
    );
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