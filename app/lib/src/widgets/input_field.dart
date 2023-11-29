
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validator, required this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 1.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: label,
          labelText: label,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)

          ),
          prefixIcon: Icon(icon),
        ),
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        controller: controller,
        validator: validator,
        onSaved: (value) => controller.text = value!,
      ),
    );
  }
}
