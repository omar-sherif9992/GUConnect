import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  final String hintText;
  final String? Function(String?)? validator;

  const PasswordField(
      {super.key,
      required this.passwordController,
      required this.hintText,
      required this.validator});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.passwordController,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        validator: widget.validator,
      ),
    );
  }
}
