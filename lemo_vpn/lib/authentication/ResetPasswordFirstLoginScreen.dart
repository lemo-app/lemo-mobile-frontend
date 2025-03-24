// import 'package:flutter/material.dart';
//
// import 'LoginScreen.dart';
//
// class ResetPasswordFirstLogInScreen extends StatefulWidget {
//   final String email; // Email passed from previous screen
//   final String tempassword; // Temporary password passed from previous screen
//
//   const ResetPasswordFirstLogInScreen({Key? key, required this.email, required this.tempassword}) : super(key: key);
//
//   @override
//   State<ResetPasswordFirstLogInScreen> createState() => _ResetPasswordFirstLogInScreenState();
// }
//
// class _ResetPasswordFirstLogInScreenState extends State<ResetPasswordFirstLogInScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController tempPasswordController = TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//
//   // Validate email (already passed, but we keep it for reference)
//   String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Email is required';
//     }
//     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//       return 'Enter a valid email';
//     }
//     return null;
//   }
//
//   // Validate password
//   String? validatePassword(String? value) {
//     if (value == null || value.length < 6) {
//       return 'Password must be at least 6 characters';
//     }
//     return null;
//   }
//
//   // Validate confirm password
//   String? validateConfirmPassword(String? value) {
//     if (value != newPasswordController.text) {
//       return 'Passwords do not match';
//     }
//     return null;
//   }
//
//   void handleSignIn() {
//     if (_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Password reset successful!')),
//       );
//       // TODO: Add actual reset password API call here
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Back button
//               SizedBox(height: 50,),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const LoginScreen()),
//                   ); // Go back to previous screen
//                 },
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: isDarkMode ? Colors.grey[800] : Colors.blueAccent.shade100,
//                   ),
//                   child: const Icon(
//                     Icons.chevron_left,
//                     size: 24,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               // New User Text
//               const Text(
//                 'New User Reset Password',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               // Form Fields
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     // Email Field (Read-only)
//                     TextFormField(
//                       initialValue: widget.email,
//                       readOnly: true,
//                       decoration: const InputDecoration(
//                         labelText: "Email",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//
//                     // Temporary Password
//                     TextFormField(
//                       initialValue: widget.tempassword,
//                       readOnly: true,
//                       obscureText: true,
//                       decoration: const InputDecoration(
//                         labelText: "Temporary Password",
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: validatePassword,
//                     ),
//                     const SizedBox(height: 15),
//
//                     // New Password
//                     TextFormField(
//                       controller: newPasswordController,
//                       obscureText: true,
//                       decoration: const InputDecoration(
//                         labelText: "New Password",
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: validatePassword,
//                     ),
//                     const SizedBox(height: 15),
//
//                     // Confirm Password
//                     TextFormField(
//                       controller: confirmPasswordController,
//                       obscureText: true,
//                       decoration: const InputDecoration(
//                         labelText: "Confirm Password",
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: validateConfirmPassword,
//                     ),
//                     const SizedBox(height: 30),
//
//                     // Sign-In Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: handleSignIn,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           backgroundColor: Colors.blueAccent
//                         ),
//                         child: const Text(
//                           "Sign In",
//                           style: TextStyle(fontSize: 16,color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import '../dashboard/DashboardScreen.dart';
import '../repository/authRepository.dart';
import '../utils/AlertDiaglogs.dart';
import 'LoginScreen.dart';

class ResetPasswordFirstLogInScreen extends StatefulWidget {
  final String email;
  final String tempassword;

  const ResetPasswordFirstLogInScreen({Key? key, required this.email, required this.tempassword}) : super(key: key);

  @override
  State<ResetPasswordFirstLogInScreen> createState() => _ResetPasswordFirstLogInScreenState();
}

class _ResetPasswordFirstLogInScreenState extends State<ResetPasswordFirstLogInScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController tempPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FocusNode newPasswordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  bool _isLoading = false;
  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    tempPasswordController.text = widget.tempassword;
  }

  @override
  void dispose() {
    tempPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    newPasswordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    final emailId = widget.email;
    final tempassword = widget.tempassword;
    final newpass = newPasswordController.text.toString().trim();
    final confirmpass = confirmPasswordController.text.toString().trim();

    print("All Data ${emailId} ${tempassword} ${newpass} ${confirmpass}");

    final success = await _authRepository.veryFyEmail(emailId, tempassword,newpass,confirmpass);

    if(success  && mounted){
      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboardscreen()),
      );

    }else{
      setState(() {
        _isLoading = false;
      });
      DiaglogUtils.showWarningDialog(context);
    }


  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard when tapping outside
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
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
                    child: const Icon(Icons.chevron_left, size: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'New User Reset Password',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.email,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: tempPasswordController,
                        readOnly: true,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Temporary Password",
                          border: OutlineInputBorder(),
                        ),
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: true,
                        focusNode: newPasswordFocus,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "New Password",
                          border: OutlineInputBorder(),
                        ),
                        validator: validatePassword,
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(confirmPasswordFocus),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        focusNode: confirmPasswordFocus,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: "Confirm Password",
                          border: OutlineInputBorder(),
                        ),
                        validator: validateConfirmPassword,
                        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSignIn,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: _isLoading ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: isDarkMode ? Colors.black : Colors.white,
                              strokeWidth: 2,
                            ),
                          ) : Text("Sign In", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ],
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
