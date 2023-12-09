import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    required this.controller,
    this.label = 'Phone Number',
  });

  final TextEditingController controller;
  final String label;
  String? validator(String? value) {
    print(value);
    if (value!.isEmpty) {
      return 'Enter a phone number';
    }
    if (value.length < 11 ) {
      return 'Enter a valid phone number';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        print(number.phoneNumber);
      },
      initialValue: PhoneNumber(isoCode: 'EG' , phoneNumber: controller.text), // Set initial country code
      textFieldController: controller,
      inputDecoration: InputDecoration(
        labelText: label,
        hintText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.phone),
      ),
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      keyboardType: TextInputType.phone,
    );
  }
}
