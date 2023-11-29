import 'package:GUConnect/src/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class EmailField extends StatefulWidget {

  final TextEditingController emailController;

  const EmailField({super.key, required this.emailController});

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.emailController,
        enabled: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter an email';
          } else if (!EmailValidator.validate(value)) {
            return 'Enter a valid email';
          } else {
            return null;
          }
        },
        decoration: const InputDecoration(
          labelText: 'Email',
          icon: Icon(Icons.email),
        ),
  
        keyboardType: TextInputType.emailAddress);
  }
}
