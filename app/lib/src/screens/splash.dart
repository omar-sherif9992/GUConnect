import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Bounce Animation
    _bounceAnimation = Tween<double>(
      begin: -500,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut, // Adjust the curve for more bounciness
      ),
    );

    // Add a delay to simulate a splash screen

    Future.delayed(const Duration(seconds: 3), () async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
     final bool loggedIn= userProvider.loggedIn;
      Navigator.pop(context);
      if (loggedIn) {
        Navigator.pushNamed(context, CustomRoutes.profile);
      } else {
        Navigator.pushNamed(context, CustomRoutes.login);
      }
    });

    // Start the animations after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You can customize this widget according to your app's design
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: Opacity(
                opacity: _opacity,
                child: Image.asset('assets/images/GUConnect-Logo.png'), // Replace with your app logo asset
              ),
            );
          },
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:GUConnect/routes.dart';

// class Splash extends StatefulWidget {
//   const Splash({Key? key}) : super(key: key);

//   @override
//   _SplashState createState() => _SplashState();
// }

// class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _bounceAnimation;
//   late Animation<double> _rotationAnimation;
//   late Animation<double> _scaleAnimation;
//   double _opacity = 0;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize AnimationController
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );

//     // Bounce Animation
//     _bounceAnimation = Tween<double>(
//       begin: -400,
//       end: 0,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.elasticOut, // Adjust the curve for more bounciness
//       ),
//     );

//     // Rotation Animation
//     _rotationAnimation = Tween<double>(
//       begin: 0,
//       end: 360,
//     ).animate(_controller);

//     // Scale Animation
//     _scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(_controller);

//     // Add a delay to simulate a splash screen
//     Future.delayed(const Duration(seconds: 3), () {
//       // Navigate to the main content of the app after the delay
//       Navigator.pushNamed(context, CustomRoutes.login);
//     });

//     // Start the animations after a short delay
//     Future.delayed(const Duration(milliseconds: 500), () {
//       _controller.forward();
//       setState(() {
//         _opacity = 1;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     // Dispose the controller when the widget is disposed
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // You can customize this widget according to your app's design
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _controller,
//           builder: (context, child) {
//             return Transform.translate(
//               offset: Offset(0, _bounceAnimation.value),
//               child: Opacity(
//                 opacity: _opacity,
//                 child: Transform.rotate(
//                   angle: _rotationAnimation.value * (3.1415927 / 180),
//                   child: Transform.scale(
//                     scale: _scaleAnimation.value,
//                     child: Image.asset('assets/images/GUConnect-Logo.png'),
//                     // Replace with your app logo asset
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

