import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:GUConnect/src/widgets/popup_menue_button.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void showToast() async {
    await showFlash(
        context: context,
        duration: const Duration(seconds: 4),
        builder: (context, controller) {
          return Flash(
            position: FlashPosition.top,
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'This is a toast',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: const CustomAppBar(
        title: 'Home',
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  showToast();
                },
                child: const Text('Toast')),
            Text(
              'You have pushed the button this many times:',
            ),
            PopupMenu()
          ],
        ),
      ),
    );
  }
}
