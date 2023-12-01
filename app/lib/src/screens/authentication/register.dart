import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
     _verifyOtp(String enteredOtp) {

      // The user is successfully verified
      Fluttertoast.showToast(
        msg: 'OTP verification successful!',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
      );
      // Handle OTP verification failure
      Fluttertoast.showToast(
        msg: 'OTP verification failed:',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
     }
    void _showOtpInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter OTP'),
          content: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter OTP',
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String enteredOtp = otpController.text;
                _verifyOtp(enteredOtp); // Verify the entered OTP
                // Close the dialog
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
    }
   _register() {
     CustomUser newUser=CustomUser.register(email: emailController.text.trim(),password: passwordController.text.trim());
     final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false); 
     userProvider.register(newUser);
      Fluttertoast.showToast(
        msg: 'Registration successful. Check your email for verification.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
      );
      userProvider.sendOtpToEmail(emailController.text.trim());
      _showOtpInputDialog();

      Fluttertoast.showToast(
        msg: 'Registration failed: ',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
      );
   }

  
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
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
           padding: const EdgeInsets.only(top:10.0),
           child: ElevatedButton(
            
             onPressed: () {
               _register();// Handle Register
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
                            Size(MediaQuery.of(context).size.width * 0.3, 50),
                        alignment: Alignment.center,
                      ),
             child: const Text(
               'Register',
               style: TextStyle(fontSize: 18), // Customize the text size if needed
             ),
           ),
         )
        ],
      ),
    );
  }
}

