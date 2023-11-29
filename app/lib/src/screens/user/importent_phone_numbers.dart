import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class ImportantPhoneNumbersScreen extends StatelessWidget {
  const ImportantPhoneNumbersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Important Phone Numbers', isLogo: false,),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Emergency'),
            subtitle: const Text('999'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Police'),
            subtitle: const Text('999'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Fire Brigade'),
            subtitle: const Text('999'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Ambulance'),
            subtitle: const Text('999'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Non-Emergency Ambulance'),
            subtitle: const Text('999'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Non-Emergency Police'),
            subtitle: const Text('999'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Non-Emergency Fire Brigade'),
            subtitle: const Text('999'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Non-Emergency Police'),
            subtitle: const Text('999'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Non-Emergency Police'),
            subtitle: const Text('999'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Non-Emergency Police'),
            subtitle: const Text('999'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Non-Emergency Police'),
            subtitle: const Text('999'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Non-Emergency Police'),
            subtitle: const Text('999'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
