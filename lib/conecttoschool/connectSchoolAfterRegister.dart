import 'package:flutter/material.dart';

import 'QrScannToConnectSchool.dart';
import 'QrScannerScreen.dart';


class ScanToConnectSchoolAfterRegister extends StatefulWidget {
  const ScanToConnectSchoolAfterRegister({super.key});

  @override
  State<ScanToConnectSchoolAfterRegister> createState() => _ScanToConnectSchoolAfterRegisterState();
}

class _ScanToConnectSchoolAfterRegisterState extends State<ScanToConnectSchoolAfterRegister> {
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
              SizedBox(height: 50,),
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
                      MaterialPageRoute(builder: (context) => const QRScannToConnectSchool()),
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