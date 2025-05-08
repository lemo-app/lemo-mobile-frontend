
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/login_screen.dart';
import '../provider/learningmode_provider.dart';
import '../repositories/auth_repository.dart';
import 'connectSchoolAfterRegister.dart';

class QRScannToConnectSchool extends StatefulWidget {
  const QRScannToConnectSchool({super.key});

  @override
  State<QRScannToConnectSchool> createState() => _QRScannToConnectSchoolState();
}

class _QRScannToConnectSchoolState extends State<QRScannToConnectSchool> {
  final AuthRepository _authRepository = AuthRepository();
  String? scannedData;
  bool isScanned = false;

  @override
  void initState() {
    super.initState();
  }


  void onDetect(BarcodeCapture capture) {
    if (!isScanned && capture.barcodes.isNotEmpty) {
      setState(() {
        scannedData = capture.barcodes.first.rawValue;
        isScanned = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            onDetect: onDetect,
          ),
          if (scannedData != null) _buildBottomNavigation(),
          _buildScannerOverlay(),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.greenAccent, width: 4),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  //Bottom nave for navigate to dashboard and show school qr result
  Widget _buildBottomNavigation() {
    final learningModeProvider = Provider.of<LearningModeProvider>(context, listen: false);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 150, // Increased height for better space
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                //create preference instance
                final prefs = await SharedPreferences.getInstance();
                final Map<String, dynamic> jsonData = json.decode(scannedData!);
                // Assign to individual variables
                String id = jsonData['_id'];
                var usermail = prefs.getString('registrationEmail');

                print(id);
                print(usermail);
                bool status = await _authRepository.conectToSchool(usermail!, id);

                if(status){
                  //Navigate user to dashboard
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }else{
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ScanToConnectSchoolAfterRegister()),
                  );
                }

                setState(() {
                  scannedData = null;
                  isScanned = false;
                });

              },
              //main bottom sheet button to handle operations
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.blue, // Button background color
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow effect
                    ),
                  ],
                ),
                child: Center(
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
