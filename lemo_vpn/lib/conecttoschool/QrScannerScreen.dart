// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
//
// import 'connectToSchool.dart';
//
//
// // QR Scanner Screen with mobile_scanner
// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({super.key});
//
//   @override
//   _QRScannerScreenState createState() => _QRScannerScreenState();
// }
//
// class _QRScannerScreenState extends State<QRScannerScreen> {
//   MobileScannerController controller = MobileScannerController();
//   bool isScanned = false;
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   void _onDetect(BarcodeCapture capture) {
//     if (!isScanned) {
//       final List<Barcode> barcodes = capture.barcodes;
//       for (final barcode in barcodes) {
//         if (barcode.rawValue != null) {
//           setState(() {
//             isScanned = true;
//           });
//           // Simulate QR validation (e.g., contains "school")
//           bool isValid = barcode.rawValue!.contains('school');
//           if (isValid) {
//             _showNextDialog(context);
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Invalid QR Code!')),
//             );
//             Future.delayed(const Duration(seconds: 2), () {
//               setState(() {
//                 isScanned = false;
//               });
//             });
//           }
//           break; // Stop after first valid scan
//         }
//       }
//     }
//   }
//
//   void _showNextDialog(BuildContext context) {
//     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('QR Code Scanned'),
//         content: const Text('Valid QR code detected! Proceed to your information.'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close dialog
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const StudentInfoScreen()),
//               );
//             },
//             child: const Text('Next'),
//           ),
//         ],
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: MobileScanner(
//         controller: controller,
//         onDetect: _onDetect,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
//
// import 'StudentInfoView.dart';
//
// // QR Scanner Screen with mobile_scanner
// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({super.key});
//
//   @override
//   _QRScannerScreenState createState() => _QRScannerScreenState();
// }
//
// class _QRScannerScreenState extends State<QRScannerScreen> {
//   MobileScannerController controller = MobileScannerController();
//   bool isScanned = false;
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   void _onDetect(BarcodeCapture capture) {
//     if (!isScanned) {
//       final List<Barcode> barcodes = capture.barcodes;
//       for (final barcode in barcodes) {
//         if (barcode.rawValue != null) {
//           setState(() {
//             isScanned = true;
//           });
//           // Any QR code is valid—show the popup immediately
//           _showNextDialog(context);
//           break; // Stop after first valid scan
//         }
//       }
//     }
//   }
//
//   void _showNextDialog(BuildContext context) {
//     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('QR Code Scanned'),
//         content: const Text('QR code detected! Proceed to your information.'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close dialog
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const StudentInfoScreen()),
//               );
//             },
//             child: const Text('Next'),
//           ),
//         ],
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: MobileScanner(
//         controller: controller,
//         onDetect: _onDetect,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String? scannedData;
  bool isScanned = false;

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

  Widget _buildBottomNavigation() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Scanned Result",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              scannedData ?? "",
              style: const TextStyle(fontSize: 16, color: Colors.greenAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  scannedData = null;
                  isScanned = false;
                });
              },
              child: const Text("Scan Again"),
            ),
          ],
        ),
      ),
    );
  }
}
