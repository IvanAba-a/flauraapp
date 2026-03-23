import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart'; // We import this to navigate back to the login page!

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers for all 5 fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Logo
              Center(
                child: Image.asset(
                  'assets/images/flaura_logo.png',
                  height: 120, // Slightly smaller than login so we don't have to scroll forever
                ),
              ),
              const SizedBox(height: 16),
              
              // 2. Title
              const Text(
                'Create your Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainAccent, // Matched the green text from your design
                ),
              ),
              const SizedBox(height: 30),
              
              // 3. Input Fields
              _buildTextField(_firstNameController, 'First Name *', Icons.person_outline),
              const SizedBox(height: 16),
              
              _buildTextField(_lastNameController, 'Last Name *', Icons.person_outline),
              const SizedBox(height: 16),
              
              _buildTextField(_emailController, 'Email *', Icons.email_outlined),
              const SizedBox(height: 16),
              
              _buildTextField(_passwordController, 'Password *', Icons.lock_outline, isPassword: true),
              const SizedBox(height: 16),
              
              _buildTextField(_confirmPasswordController, 'Confirm Password *', Icons.lock_outline, isPassword: true),
              const SizedBox(height: 30),
              
              // 4. Sign Up Button
              ElevatedButton(
                onPressed: () {
                  // Firebase Account Creation Logic will go here!
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
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18, 
                    color: AppColors.white, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 5. Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: AppColors.lightAccent),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate back to Login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.mainAccent,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- REUSABLE HELPER: Keeps the UI code clean and prevents 100 lines of repetitive TextField code ---
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: AppColors.textAccent),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.lightAccent),
        prefixIcon: Icon(icon, color: AppColors.mainAccent),
        // Adds the little eyeball icon on the right side if it's a password field!
        suffixIcon: isPassword ? const Icon(Icons.visibility_off, color: AppColors.lightAccent) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightAccent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mainAccent, width: 2),
        ),
      ),
    );
  }
}