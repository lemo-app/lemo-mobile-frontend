import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../authentication/login_screen.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({super.key});

  @override
  State<IntroSliderScreen> createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> slides = [
    {
      'image': 'assets/images/school_boy_reading.png',
      'title': 'Focus on Learning',
      'description':
          'Lemo helps you stay focused during school hours by blocking distracting websites and apps.',
    },
    {
      'image': 'assets/images/school_boy_with_notebook.png',
      'title': 'Safe & Private',
      'description':
          'We don\'t store any of your data. Lemo only establishes a secure VPN connection to help you focus.',
    },
    {
      'image': 'assets/images/girl_and_boy.png',
      'title': 'Easy to Use',
      'description':
          'Simply scan your school\'s QR code to activate learning mode and stay focused on your studies.',
    },
  ];

  void _nextImage() {
    if (_currentIndex < slides.length - 1) {
      _currentIndex++;
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 350,
            child: PageView.builder(
              controller: _pageController,
              itemCount: slides.length,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage(slides[index]['image']!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        slides[index]['title']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          slides[index]['description']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode
                                ? Colors.grey[300]
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12),
          SmoothPageIndicator(
            controller: _pageController,
            count: slides.length,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: Colors.blueAccent,
              dotColor: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _nextImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              _currentIndex == slides.length - 1 ? 'Get Started' : 'Next',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
