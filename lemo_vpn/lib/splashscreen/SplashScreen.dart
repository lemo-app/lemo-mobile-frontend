import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
    super.initState();
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
                        'assets/background.png', // Replace with your background image
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
                      'assets/usershield.png',
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
            // Center(
            //   child: Stack(
            //     alignment: Alignment.center, // Centers both images
            //     children: [
            //       // Background Image
            //       Opacity(
            //         opacity: 0.2,
            //         child: Image.asset(
            //           'assets/background.png', // Replace with your background image
            //           width: 600, // Adjust size as needed
            //           height: 500,
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //
            //       // Foreground Image and Text
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Image.asset(
            //             'assets/usershield.png',
            //             width: 150,
            //             height: 150,
            //           ),
            //           Text(
            //             'LEMO',
            //             style: TextStyle(
            //               fontSize: 24,
            //               fontWeight: FontWeight.bold,
            //               color: isDarkMode ? Colors.white : Colors.black,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

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