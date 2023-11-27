import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:GUConnect/src/widgets/popup_menue_button.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      drawer: MainDrawer(),
      appBar: CustomAppBar(
        title: 'Home', actions: [], isAuthenticated: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
