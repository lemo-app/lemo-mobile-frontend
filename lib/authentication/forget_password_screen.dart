import 'package:flutter/material.dart';

import '../repositories/auth_repository.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Authentication Repository for login
  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  void _resetPassword() async{
    if (_formKey.currentState!.validate()) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
      // );
      setState(() {
        _isLoading = true;
      });
      bool paswwordForget = await _authRepository.forgetPassword(_emailController.text.toString());
      if(paswwordForget){
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password reset link sent to ${_emailController.text}")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }else{
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed To Send Password reset link sent to ${_emailController.text}")),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              // Circular Back Button
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[200] : Colors.blueAccent.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.chevron_left, size: 28, color: isDarkMode ? Colors.black87 : Colors.white),
                ),
              ),
              SizedBox(height: 30),
              // Title
              Text(
                "Forget Password",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white :Colors.black),
              ),
              SizedBox(height: 10),
              // Email Input Field
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    } else if (!_isValidEmail(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              // Reset Password Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _resetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blueAccent.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading ?  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: isDarkMode ? Colors.black : Colors.white,
                      strokeWidth: 2,
                    ),
                  ):Text("Reset Password", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),
              // Remember Password? Sign In
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to Sign In screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Remember password? ",
                      style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white : Colors.black87),
                      children: [
                        TextSpan(
                          text: "Sign in",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                      ],
                    ),
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
