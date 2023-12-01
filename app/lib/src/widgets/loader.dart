import 'package:flutter/material.dart';



class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Adjust the duration as needed
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: RotationTransition(
          turns: _controller,
          child: Image.asset(
            'assets/images/logo_icon.png', // Path to your logo image
            width: 100, // Adjust width as needed
            height: 100, // Adjust height as needed
            fit: BoxFit.fitHeight,
          ),
        ),
    );
  }
}
