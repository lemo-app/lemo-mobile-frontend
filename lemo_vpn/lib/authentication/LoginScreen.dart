import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../dashboard/DashboardScreen.dart';
import '../repository/authRepository.dart';
import 'ForgetPassword.dart';
import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final AuthRepository _authRepository = AuthRepository();

  void _handleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    final emailId = _email;
    final password = _password;

    final success = await _authRepository.signIn(emailId, password);
    print("Sucess: ${success}");

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboardscreen()),
      );
    }else{
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Login Failed!")),
      // );
      _showWarningDialog(context);
    }
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row with Icon on Left & Text on Right
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Warning Icon (Left Side)
                    Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 10),

                    // Warning Title & Message (Right Side)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Warning!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Invalid Username Or Password Check Them Correctly.",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // "Okay" Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close Dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Okay",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void _showWarningDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         child: Container(
  //           padding: const EdgeInsets.all(20),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // Warning Icon
  //               Icon(
  //                 Icons.error_outline,
  //                 size: 50,
  //                 color: Colors.red,
  //               ),
  //               const SizedBox(height: 10),
  //
  //               // Warning Title
  //               const Text(
  //                 "Warning!",
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //
  //               // Warning Message
  //               const Text(
  //                 "Invalid Username Or Password.",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 16, color: Colors.black54),
  //               ),
  //               const SizedBox(height: 20),
  //
  //               // "Okay" Button
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop(); // Close Dialog
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.red,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     padding: const EdgeInsets.symmetric(vertical: 12),
  //                   ),
  //                   child: const Text(
  //                     "Okay",
  //                     style: TextStyle(color: Colors.white, fontSize: 16),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
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
                    Navigator.pop(context); // Go back to previous screen
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
                    child: _isLoading ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome Back!')),
    );
  }
}
