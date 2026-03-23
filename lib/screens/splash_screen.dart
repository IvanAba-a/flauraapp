import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart'; 
import '../utils/plant_tips.dart'; // Import your new tip bank!

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String _currentTip;

  @override
  void initState() {
    super.initState();
    // Fetch a random tip the exact millisecond the screen loads
    _currentTip = PlantTips.getRandomTip();

    // Increased timer to 4 seconds so the user actually has time to read the tip
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4EE),  
      body: Stack(
        children: [
          // 1. TOP HALF: The Logo
          // Positioned.bottom perfectly aligns the bottom edge of this widget to the exact center of the screen
          Positioned(
            bottom: MediaQuery.of(context).size.height / 2,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/flaura_logo.png',
                height: 300, // Tweak this if your logo is too big/small
              ),
            ),
          ),
          
          // 2. BOTTOM HALF: Text, Loader, and Tip
          // Positioned.top perfectly starts this widget from the exact center and builds downward
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // The Random Tip
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    _currentTip,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}