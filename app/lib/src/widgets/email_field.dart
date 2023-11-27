import 'package:GUConnect/src/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class EmailField extends StatefulWidget {
  // const EmailField({Key? key}) : super(key: key);

  final TextEditingController emailController;

  const EmailField({super.key, required this.emailController});

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return InputField(
        controller: widget.emailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter an email';
          } else if (!EmailValidator.validate(value)) {
            return 'Enter a valid email';
          } else {
            return null;
          }
        },
        label: 'email',
        icon: Icons.email,
        keyboardType: TextInputType.emailAddress);
  }
}
