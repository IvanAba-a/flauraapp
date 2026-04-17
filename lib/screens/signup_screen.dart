import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // NEW: Firebase Auth
import '../utils/app_colors.dart';
import 'login_screen.dart'; 
import 'dashboard_screen.dart'; // NEW: Route directly to dashboard on success

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false; // Prevents spam-clicking the button

  // --- FIREBASE SIGNUP LOGIC ---
  Future<void> _signUp() async {
    // 1. Check if passwords match
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match!"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      // 2. Tell Firebase to create the account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 3. If successful, go straight to the Dashboard!
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // 4. Catch errors (like "email already in use" or "weak password")
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An error occurred"), backgroundColor: Colors.red),
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Image.asset('assets/images/flaura_logo.png', height: 120)),
              const SizedBox(height: 16),
              const Text(
                'Create your Account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.mainAccent),
              ),
              const SizedBox(height: 30),
              
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
              
              // 4. Sign Up Button updated with _isLoading check
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp, // Disables button while loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Sign Up', style: TextStyle(fontSize: 18, color: AppColors.white, fontWeight: FontWeight.bold)),
              ),
              
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?', style: TextStyle(color: AppColors.lightAccent)),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                    child: const Text('Login', style: TextStyle(color: AppColors.mainAccent, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: AppColors.textAccent),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.lightAccent),
        prefixIcon: Icon(icon, color: AppColors.mainAccent),
        suffixIcon: isPassword ? const Icon(Icons.visibility_off, color: AppColors.lightAccent) : null,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightAccent, width: 1)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.mainAccent, width: 2)),
      ),
    );
  }
}