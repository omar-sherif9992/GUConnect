import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:GUConnect/src/widgets/popup_menue_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void showToast() {

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: MainDrawer(),
      appBar: CustomAppBar(
        title: 'Home',
        actions: [],
        isAuthenticated: false,
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
