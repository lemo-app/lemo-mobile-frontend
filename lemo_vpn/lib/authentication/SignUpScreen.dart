// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
//
// import 'LoginScreen.dart';
//
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//
//   final _formKey = GlobalKey<FormState>();
//   String _fullName = '';
//   String _phoneNumber = '';
//   String _email = '';
//   String _password = '';
//   bool _isPasswordVisible = false;
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Back Button
//                   SizedBox(height: 50,),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => const LoginScreen()),
//                       ); // Go back to previous screen
//                     },
//                     child: Container(
//                       width: 40,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: isDarkMode ? Colors.grey[800] : Colors.blueAccent.shade100,
//                       ),
//                       child: const Icon(
//                         Icons.chevron_left,
//                         size: 24,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Sign Up Text
//                   const Text(
//                     'Sign Up',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   // Full Name Field
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Full Name',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your full name';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) {
//                       setState(() {
//                         _fullName = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   // Phone Number Field
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Phone Number',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     keyboardType: TextInputType.phone,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your phone number';
//                       }
//                       if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                         return 'Please enter a valid 10-digit phone number';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) {
//                       setState(() {
//                         _phoneNumber = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   // Email Field
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) {
//                       setState(() {
//                         _email = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   // Password Field
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _isPasswordVisible = !_isPasswordVisible;
//                           });
//                         },
//                       ),
//                     ),
//                     obscureText: !_isPasswordVisible,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) {
//                       setState(() {
//                         _password = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                   // Sign Up Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           print('Name: $_fullName, Phone: $_phoneNumber, Email: $_email, Password: $_password');
//                           // Navigator.pushReplacement(
//                           //   context,
//                           //   MaterialPageRoute(builder: (context) => const HomeScreen()),
//                           // );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: isDarkMode ? Colors.white : Colors.blueAccent.shade100,
//                         foregroundColor: isDarkMode ? Colors.black : Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20), // Circular corners
//                         ),
//                       ),
//                       child: const Text(
//                         'Sign Up',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Sign In Text
//                   Center(
//                     child: RichText(
//                       text: TextSpan(
//                         style: TextStyle(
//                           color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
//                           fontSize: 14,
//                         ),
//                         children: [
//                           const TextSpan(text: 'Already have an account? '),
//                           TextSpan(
//                             text: 'Sign in',
//                             style: const TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = () {
//                                 print('Sign in tapped!');
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                                 );
//                               },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../repository/authRepository.dart';
import 'LoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _selectedUserType = "student";
  bool _isLoading = false;
  final AuthRepository _authRepository = AuthRepository();

  final List<String> _userTypes = [
    'admin',
    'super-admin',
    'school_manager',
    'student'
  ];

  void _handleSignUp() async {
    setState(() {
      _isLoading = true;
    });

    final emailId = _email;
    final userType = _selectedUserType;

    final success = await _authRepository.signUp(emailId, userType);
    print("Sucess: ${success}");

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Up Successfull!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
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

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  const SizedBox(height: 50),
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

                  // Sign Up Text
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Full Name Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _fullName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  TextFormField(
                    decoration: InputDecoration(
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

                  // User Type Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select User Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: _selectedUserType,
                    items: _userTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUserType = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a user type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print('Name: $_fullName, Email: $_email, UserType: $_selectedUserType');
                          // Navigate to next screen
                          _handleSignUp();
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
                      ):const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign In Text
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Sign in',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
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
      ),
    );
  }
}

