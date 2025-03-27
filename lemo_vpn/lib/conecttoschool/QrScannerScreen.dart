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

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../dashboard/DashboardScreen.dart';
import '../provider/LearningModeProvider.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Center(
          //     child: (result != null)
          //         ? Text(
          //         'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //         : Text('Scan a code'),
          //   ),
          // )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if(result != null){
        _showBottomSheet(context, result!.code!);
      }
    });
  }

  // Function to display the BottomSheet
  void _showBottomSheet(BuildContext context, String scannedData) {
    controller?.pauseCamera();
    final learningModeProvider = Provider.of<LearningModeProvider>(context,listen: false);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display Scanned QR Code Result
            Text(
              'Scanned Data: $scannedData',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close BottomSheet
                  },
                  child: const Text('OK'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (learningModeProvider.isLearningModeActive) {
                      learningModeProvider.stopLearningMode();
                      learningModeProvider.resetLearningMode();
                    } else {
                      learningModeProvider.startLearningMode();
                    }
                    // Navigate to Dashboard Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboardscreen(),
                      ),
                    );
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      );
    },
    ).whenComplete((){
      // Resume camera after BottomSheet is dismissed
      controller?.resumeCamera();
    });
  }

}
