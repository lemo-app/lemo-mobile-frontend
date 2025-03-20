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

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'StudentInfoView.dart';

// QR Scanner Screen with mobile_scanner
class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  bool isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!isScanned) {
      final List<Barcode> barcodes = capture.barcodes;
      for (final barcode in barcodes) {
        if (barcode.rawValue != null) {
          setState(() {
            isScanned = true;
          });
          // Any QR code is valid—show the popup immediately
          _showNextDialog(context);
          break; // Stop after first valid scan
        }
      }
    }
  }

  void _showNextDialog(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Scanned'),
        content: const Text('QR code detected! Proceed to your information.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StudentInfoScreen()),
              );
            },
            child: const Text('Next'),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: controller,
        onDetect: _onDetect,
      ),
    );
  }
}