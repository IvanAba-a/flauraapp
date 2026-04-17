import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // NEW: Firebase Auth
import '../utils/app_colors.dart';
import 'dashboard_screen.dart';
import 'signup_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;

  // --- FIREBASE LOGIN LOGIC ---
  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      // 1. Tell Firebase to verify credentials
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. If successful, route to Dashboard!
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // 3. Show error if wrong password or user not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Center(child: Image.asset('assets/images/flaura_logo.png', height: 100)),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Flaura',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textAccent),
              ),
              const SizedBox(height: 40),
              
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: AppColors.textAccent),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: const TextStyle(color: AppColors.lightAccent),
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.mainAccent),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightAccent, width: 1)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.mainAccent, width: 2)),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: AppColors.textAccent),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: AppColors.lightAccent),
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.mainAccent),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightAccent, width: 1)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.mainAccent, width: 2)),
                ),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignupScreen())),
                    child: const Text('Create Account', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?', style: TextStyle(color: AppColors.mainAccent, fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // 4. Login Button updated with _isLoading check
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login', style: TextStyle(fontSize: 18, color: AppColors.white, fontWeight: FontWeight.bold)),
              ),
              
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.lightAccent.withValues(alpha: 0.5))),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text('OR', style: TextStyle(color: AppColors.lightAccent))),
                  Expanded(child: Divider(color: AppColors.lightAccent.withValues(alpha: 0.5))),
                ],
              ),
              const SizedBox(height: 30),

              OutlinedButton(
                onPressed: () {}, 
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16), 
                  side: BorderSide(color: AppColors.lightAccent.withValues(alpha: 0.3), width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Continue with Google', style: TextStyle(fontSize: 16, color: AppColors.lightAccent, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}