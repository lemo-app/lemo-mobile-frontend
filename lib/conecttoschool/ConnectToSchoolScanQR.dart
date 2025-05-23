import 'package:flutter/material.dart';

import '../dashboard/DashboardScreen.dart';
import 'QrScannerScreen.dart';


class ScanToConnectSchool extends StatefulWidget {
  const ScanToConnectSchool({super.key});

  @override
  State<ScanToConnectSchool> createState() => _ScanToConnectSchoolState();
}

class _ScanToConnectSchoolState extends State<ScanToConnectSchool> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Text: Connect to School
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboardscreen()),
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
              SizedBox(height: 20,),
              const Text(
                'Connect to School',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Small Text: Step 1
              Text(
                'Step 1: Scan School QR Code',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // QR Code with Corner Border
              Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/qr_code.png',
                        width: 400,
                        height: 400,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isDarkMode ? Colors.white : Colors.black,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              right: BorderSide(
                                color: isDarkMode ? Colors.white : Colors.black,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              top: BorderSide.none,
                              left: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 360,
                        right: 320,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide.none,
                              right: BorderSide.none,
                              top: BorderSide(
                                color: isDarkMode ? Colors.white : Colors.black,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              left: BorderSide(
                                color: isDarkMode ? Colors.white : Colors.black,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 360,
                        right: 0,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide.none,
                              right: BorderSide(
                                color: isDarkMode ? Colors.white : Colors.black,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              top: BorderSide(
                                color: isDarkMode ? Colors.white : Colors.black,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              left: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 320,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isDarkMode ? Colors.white : Colors.black,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              right: BorderSide.none,
                              top: BorderSide.none,
                              left: BorderSide(
                                color: isDarkMode ? Colors.white : Colors.black,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // Row: Avatar + School Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    child: const Icon(
                      Icons.school,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "St. Thomas' Moorside",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              //const Spacer(), // Pushes button to bottom
              SizedBox(height: 30,),
              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.white : Colors.blueAccent,
                    foregroundColor: isDarkMode ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Circular border
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18),
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