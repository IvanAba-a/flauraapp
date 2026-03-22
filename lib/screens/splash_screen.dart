import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart'; // We will build this next!

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // This timer waits 3 seconds, then automatically transitions to the Dashboard
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is the vibrant green color from your design
      backgroundColor: const Color(0xFF65B741), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your Logo
            Image.asset(
              'assets/images/flaura_logo.png',
              width: 120, // Adjust size as needed
            ),
            const SizedBox(height: 20),
            // The Text
            const Text(
              'FLAURA',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 5.0, // Spaces out the letters exactly like your design
              ),
            ),
          ],
        ),
      ),
    );
  }
}