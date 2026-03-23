import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'dashboard_screen.dart';
import 'signup_screen.dart'; // We imported your new Signup Screen!

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              
              // 1. Logo
              Center(
                child: Image.asset(
                  'assets/images/flaura_logo.png',
                  height: 100, 
                ),
              ),
              const SizedBox(height: 24),
              
              // 2. Text
              const Text(
                'Welcome to Flaura',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textAccent, 
                ),
              ),
              const SizedBox(height: 40),
              
              // 3. Field 1 (Email)
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: AppColors.textAccent),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: const TextStyle(color: AppColors.lightAccent),
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.mainAccent),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.lightAccent, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.mainAccent, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 4. Field 2 (Password)
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: AppColors.textAccent),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: AppColors.lightAccent),
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.mainAccent),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.lightAccent, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.mainAccent, width: 2),
                  ),
                ),
              ),
              
              // 5. Secondary Actions (Sign Up & Forgot Password side-by-side)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CREATE ACCOUNT (Left side, subtle & grey)
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.grey, // Gives it that disabled/unobtrusive look you wanted
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  // FORGOT PASSWORD (Right side, accented)
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.mainAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // 6. Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18, 
                    color: AppColors.white, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Divider for Google Login
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.lightAccent.withOpacity(0.5))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('OR', style: TextStyle(color: AppColors.lightAccent)),
                  ),
                  Expanded(child: Divider(color: AppColors.lightAccent.withOpacity(0.5))),
                ],
              ),
              const SizedBox(height: 30),

              // 7. Login with Google (Secondary Styled)
              OutlinedButton(
                onPressed: () {}, 
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16), 
                  side: BorderSide(
                    color: AppColors.lightAccent.withOpacity(0.3), 
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), 
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.lightAccent, 
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}