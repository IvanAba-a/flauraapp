import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const FlauraApp());
}

class FlauraApp extends StatelessWidget {
  const FlauraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flaura',
      debugShowCheckedModeBanner: false, // Removes the ugly "DEBUG" banner
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF3F4EE),
        ),
      home: SplashScreen(), // Starts the app here!
    );
  }
}