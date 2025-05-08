import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lemoios/authentication/reset_password_firstuser_screen.dart';
import 'package:lemoios/authentication/signup_screen.dart';

import '../dashboard/DashboardScreen.dart';
import '../introslider/IntroSlider.dart';
import '../repositories/auth_repository.dart';
import '../utils/AlertDiaglogs.dart';
import 'forget_password_screen.dart';

// Main Login Screen Widget
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
// Form key to validate the form fields
  final _formKey = GlobalKey<FormState>();
  String _email = ''; // User input for email
  String _password = ''; // User input for password
  bool _isPasswordVisible = false; // To toggle password visibility
  bool _isLoading = false; // To show loading spinner during API calls
  // Authentication Repository for login
  final AuthRepository _authRepository = AuthRepository();


  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    // First, check if there's any network connection
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    // Then, check if actual internet is available
    try {
      final result = await InternetAddress.lookup('google.com'); // or 'example.com'
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }


  // Function to handle sign in logic
  void _handleSignIn() async {
    setState(() {
      _isLoading = true; // Show loading spinner when sign-in is in progress
    });

    // Check for internet connection
    final hasInternet = await _hasInternetConnection();
    print("has internet: ${hasInternet}");
    if (!hasInternet) {
      setState(() {
        _isLoading = false;
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("No internet connection"),
      //     duration: Duration(seconds: 2),
      //     behavior: SnackBarBehavior.floating,
      //   ),
      // );

      DiaglogUtils.showWarningNoInternetDialog(context);

      return;
    }

    final emailId = _email;
    final password = _password;

    // Calling the signIn function from AuthRepository to perform login
    final success = await _authRepository.signIn(emailId, password);
    print("Login Success: ${success}");
    // Check if user is not verified (first time login)
    if(success == "Error logging in: User not verified. Please verify your email before logging in" && mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("First User")),
      );
      setState(() {
        _isLoading = false;
      });
      // Navigate to ResetPasswordFirstLogInScreen if user is first time logging in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordFirstLogInScreen(email:emailId,tempassword: password,)),
      );
    // Check if login is successful
    }else if(success == "true" && mounted){

      setState(() {
        _isLoading = false;
      });
      // Navigate to the Dashboard after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboardscreen()),
      );

    }else{
      setState(() {
        _isLoading = false;
      });
      // If login fails, show a warning dialog
      DiaglogUtils.showWarningDialog(context);
    }


  }




  @override
  Widget build(BuildContext context) {
    // Check if the app is in dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                SizedBox(height: 50,),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => IntroSliderScreen()),
                    ); // Go back to previous screen
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode ? Colors.grey[800] : Colors.blueAccent.shade100,
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sign In Text
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                // Email Field
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Password Field
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      print('Forgot Password tapped!');
                      // Add navigation to reset password screen here
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print('Email: $_email, Password: $_password');
                        // Handle sign-in when the button is pressed
                        _handleSignIn();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.white : Colors.blueAccent.shade100,
                      foregroundColor: isDarkMode ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Circular corners
                      ),
                    ),
                    child: _isLoading ?  SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: isDarkMode ? Colors.black : Colors.white,
                        strokeWidth: 2,
                      ),
                    ) :const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sign Up Text
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: "I'm a new user. "),
                        TextSpan(
                          text: 'Sign up',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Sign up tapped!');
                              // Add navigation to sign-up screen here
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpScreen()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
