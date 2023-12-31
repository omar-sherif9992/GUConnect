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
          if (value == null) {
            return 'Enter an email';
          } else if (value.isEmpty) {
            return 'Enter an email';
          } else if (!EmailValidator.validate(value)) {
            return 'Enter a valid GUC email';
          } else if (!value.contains('guc.edu.eg')) {
            return 'Enter a valid GUC email .guc.edu.eg';
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Email',
          hintText: 'name@student.guc.edu.eg',  
          prefixIcon: Icon(Icons.email),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        onSaved: (value) => widget.emailController.text = value!,
        keyboardType: TextInputType.emailAddress);
  }
}
