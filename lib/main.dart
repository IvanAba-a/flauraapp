import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// 1. Import your splash screen so the app knows where to start!
import 'screens/splash_screen.dart'; 

// 2. We add 'async' here because Firebase needs a moment to connect to the internet
void main() async {
  // 3. This line is REQUIRED by Flutter before doing anything asynchronous in main()
  WidgetsFlutterBinding.ensureInitialized();
  
  // 4. This boots up Firebase using the config file we generated earlier!
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FlauraApp());
}

class FlauraApp extends StatelessWidget {
  const FlauraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flaura',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF3F4EE), // Your custom background
      ),
      home: const SplashScreen(), 
    );
  }
}