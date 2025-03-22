import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/LoginScreen.dart';
import '../dashboard/DashboardScreen.dart';
import '../introslider/IntroSlider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isChecked = false; // Tracks checkbox state

  @override
  void initState() {
    _checkAuthAndNavigate();
    super.initState();
  }


  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboardscreen()),
        );
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // App Icon in the middle
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/usershield.png',
                    width: 150,
                    height: 150,
                  ),
                  Text(
                    'LEMO',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Checkbox, Policy Text, and Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Checkbox Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                          activeColor: isDarkMode ? Colors.white : Colors.blue,
                        ),
                        // Policy Text
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                              fontSize: 14,
                            ),
                            children: [
                              const TextSpan(text: 'By clicking \'Get Started\' you agree to our\n '),
                              TextSpan(
                                text: ' Privacy Policy',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('Privacy Policy tapped!');
                                    // Add navigation to Privacy Policy here
                                  },
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('Terms and Conditions tapped!');
                                    // Add navigation to Terms here
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    // Get Started Button
                    ElevatedButton(
                      onPressed: _isChecked
                          ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const IntroSliderScreen()),
                        );
                      }
                          : null, // Disabled if checkbox isn’t checked
                      style: ElevatedButton.styleFrom(
                        foregroundColor: isDarkMode ? Colors.blue : Colors.white,
                        backgroundColor: isDarkMode ? Colors.white : Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Circular border
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // App Name and Version
                    Column(
                      children: [
                        Text(
                          'v1.0.0',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}