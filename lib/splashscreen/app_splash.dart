
import 'package:flutter/material.dart';
import 'package:lemoios/splashscreen/terms_conditions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/login_screen.dart';
import '../dashboard/DashboardScreen.dart';


class AppSplash extends StatefulWidget {
  const AppSplash({super.key});

  @override
  _AppSplashState createState() => _AppSplashState();
}

class _AppSplashState extends State<AppSplash> {
  bool _isChecked = false; // Tracks checkbox state

  @override
  void initState() {
    _checkAuthAndNavigate();
    super.initState();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3)); // Show splash for 3 seconds

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true; // Default to true if not set
    final token = prefs.getString('token');

    if (isFirstLaunch) {
      // First time launching, show IntroSlider and update flag
      await prefs.setBool('isFirstLaunch', false);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TermsAndConditionScreen()),
        );
      }
    } else if (token != null) {
      // If user is logged in, go to Dashboard
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboardscreen()),
        );
      }
    } else {
      // Otherwise, go to Login Screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // App Icon in the middle
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Faded Background Image
                  Positioned(
                    top: screenHeight * .05, // Adjust positioning
                    child:  Opacity(
                      opacity: 0.2, // Adjust opacity for fade effect
                      child: Image.asset(
                        'assets/images/background.png', // Replace with your background image
                        width: screenWidth * 1.25,
                        height: screenHeight * 0.65,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Foreground Image (Shield)
                  Positioned(
                    top: 220, // Adjust positioning
                    child: Image.asset(
                      'assets/images/usershield.png',
                      width: 120,
                      height: 120,
                    ),
                  ),

                  // Text Positioned Below the Shield
                  Positioned(
                    top: 320, // Adjust this value to move text closer or farther
                    child: Text(
                      'LEMO',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
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
