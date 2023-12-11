import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Your company/team logo or image
            Container(
              margin: const EdgeInsets.only(bottom: 15.0),
              child: Image.asset(
                'assets/images/GUConnect-Logo.png', // Replace with your image path
                width: 150,
                height: 150,
                // You can adjust width and height as needed
              ),
            ),
            // Description or information about your company/team
            const Text(
              '"Welcome to GUConnect!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              "Your Premier Social Hub for GUC Students and Academics! At GUConnect, we're dedicated to fostering a vibrant and inclusive digital community tailored specifically for the esteemed students and revered academics of the German University in Cairo (GUC). As a pioneering social media platform, our mission is to connect, engage, and empower the diverse and dynamic members of the GUC family. Whether you're seeking academic guidance, forming study groups, exploring extracurricular activities, or simply looking to connect with like-minded individuals, GUConnect is your gateway to a thriving community experience at GUC.Get started today and embark on a journey of connectivity, collaboration, and growth with GUConnect – where the GUC spirit thrives online! Connect. Engage. Inspire. Welcome to GUConnect! ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            // Additional information or team members section
            // You can add more widgets as needed
          ],
        ),
      ),
    );
  }
}


