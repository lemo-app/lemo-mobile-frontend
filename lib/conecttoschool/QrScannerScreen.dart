// // import 'package:flutter/material.dart';
// // import 'package:mobile_scanner/mobile_scanner.dart';
// //
// // import 'connectToSchool.dart';
// //
// //
// // // QR Scanner Screen with mobile_scanner
// // class QRScannerScreen extends StatefulWidget {
// //   const QRScannerScreen({super.key});
// //
// //   @override
// //   _QRScannerScreenState createState() => _QRScannerScreenState();
// // }
// //
// // class _QRScannerScreenState extends State<QRScannerScreen> {
// //   MobileScannerController controller = MobileScannerController();
// //   bool isScanned = false;
// //
// //   @override
// //   void dispose() {
// //     controller.dispose();
// //     super.dispose();
// //   }
// //
// //   void _onDetect(BarcodeCapture capture) {
// //     if (!isScanned) {
// //       final List<Barcode> barcodes = capture.barcodes;
// //       for (final barcode in barcodes) {
// //         if (barcode.rawValue != null) {
// //           setState(() {
// //             isScanned = true;
// //           });
// //           // Simulate QR validation (e.g., contains "school")
// //           bool isValid = barcode.rawValue!.contains('school');
// //           if (isValid) {
// //             _showNextDialog(context);
// //           } else {
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               const SnackBar(content: Text('Invalid QR Code!')),
// //             );
// //             Future.delayed(const Duration(seconds: 2), () {
// //               setState(() {
// //                 isScanned = false;
// //               });
// //             });
// //           }
// //           break; // Stop after first valid scan
// //         }
// //       }
// //     }
// //   }
// //
// //   void _showNextDialog(BuildContext context) {
// //     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('QR Code Scanned'),
// //         content: const Text('Valid QR code detected! Proceed to your information.'),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context); // Close dialog
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => const StudentInfoScreen()),
// //               );
// //             },
// //             child: const Text('Next'),
// //           ),
// //         ],
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: MobileScanner(
// //         controller: controller,
// //         onDetect: _onDetect,
// //       ),
// //     );
// //   }
// // }
//
// // import 'package:flutter/material.dart';
// // import 'package:mobile_scanner/mobile_scanner.dart';
// //
// // import 'StudentInfoView.dart';
// //
// // // QR Scanner Screen with mobile_scanner
// // class QRScannerScreen extends StatefulWidget {
// //   const QRScannerScreen({super.key});
// //
// //   @override
// //   _QRScannerScreenState createState() => _QRScannerScreenState();
// // }
// //
// // class _QRScannerScreenState extends State<QRScannerScreen> {
// //   MobileScannerController controller = MobileScannerController();
// //   bool isScanned = false;
// //
// //   @override
// //   void dispose() {
// //     controller.dispose();
// //     super.dispose();
// //   }
// //
// //   void _onDetect(BarcodeCapture capture) {
// //     if (!isScanned) {
// //       final List<Barcode> barcodes = capture.barcodes;
// //       for (final barcode in barcodes) {
// //         if (barcode.rawValue != null) {
// //           setState(() {
// //             isScanned = true;
// //           });
// //           // Any QR code is valid—show the popup immediately
// //           _showNextDialog(context);
// //           break; // Stop after first valid scan
// //         }
// //       }
// //     }
// //   }
// //
// //   void _showNextDialog(BuildContext context) {
// //     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('QR Code Scanned'),
// //         content: const Text('QR code detected! Proceed to your information.'),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context); // Close dialog
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => const StudentInfoScreen()),
// //               );
// //             },
// //             child: const Text('Next'),
// //           ),
// //         ],
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: MobileScanner(
// //         controller: controller,
// //         onDetect: _onDetect,
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:provider/provider.dart';
// import 'package:vpn_basic_project/dashboard/DashboardScreen.dart';
//
// import '../models/vpn_config.dart';
// import '../provider/learningmode_provider.dart';
// import '../services/vpn_engine.dart';
//
// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({super.key});
//
//   @override
//   State<QRScannerScreen> createState() => _QRScannerScreenState();
// }
//
// class _QRScannerScreenState extends State<QRScannerScreen> {
//   String _vpnState = VpnEngine.vpnDisconnected;
//   List<VpnConfig> _listVpn = [];
//   VpnConfig? _selectedVpn;
//   String? scannedData;
//   bool isScanned = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     VpnEngine.vpnStageSnapshot().listen((event) {
//       setState(() => _vpnState = event);
//       if (event == VpnEngine.vpnDisconnected) {
//
//       } else if (event == VpnEngine.vpnConnected) {
//         // Changed from "CONNECTED" to VpnEngine.vpnConnected
//         // Only start timer when connected
//
//       }
//     });
//     initVpn();
//   }
//
//   void initVpn() async {
//     _listVpn.add(VpnConfig(
//         config: await rootBundle.loadString('assets/vpn/test.ovpn'),
//         country: 'Demo',
//         username: 'xwing',
//         password: 'fender92'));
//
//     SchedulerBinding.instance.addPostFrameCallback(
//             (t) => setState(() => _selectedVpn = _listVpn.first));
//   }
//
//   void _connectClick() async {
//     log("Connect button clicked. Current VPN state: $_vpnState");
//     VpnEngine.startVpn(_selectedVpn!);
//   }
//
//   void _disconnectVpn()async{
//     log("DisConnect button clicked. Current VPN state: $_vpnState");
//     VpnEngine.stopVpn();
//   }
//
//   void onDetect(BarcodeCapture capture) {
//     if (!isScanned && capture.barcodes.isNotEmpty) {
//       setState(() {
//         scannedData = capture.barcodes.first.rawValue;
//         isScanned = true;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           MobileScanner(
//             onDetect: onDetect,
//           ),
//           if (scannedData != null) _buildBottomNavigation(),
//           _buildScannerOverlay(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildScannerOverlay() {
//     return Align(
//       alignment: Alignment.center,
//       child: Container(
//         width: 250,
//         height: 250,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.greenAccent, width: 4),
//           borderRadius: BorderRadius.circular(16),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomNavigation() {
//     final learningModeProvider = Provider.of<LearningModeProvider>(context,listen: false);
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         height: 200,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.black87,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Scanned Result",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               scannedData ?? "",
//               style: const TextStyle(fontSize: 16, color: Colors.greenAccent),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   scannedData = null;
//                   isScanned = false;
//                 });
//                 if (learningModeProvider.isLearningModeActive) {
//                   learningModeProvider.stopLearningMode();
//                   learningModeProvider.resetLearningMode();
//                 } else {
//                   learningModeProvider.startLearningMode();
//                 }
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const Dashboardscreen()),
//                 );
//               },
//               child: const Text("Next"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/DashboardScreen.dart';
import '../models/vpn_config.dart';
import '../provider/learningmode_provider.dart';
import '../repositories/qr_repository.dart';
import '../services/vpn_engine.dart';
import '../utils/AlertDiaglogs.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final QrRepository _qrRepository = QrRepository();
  //String _vpnState = VpnEngine.vpnDisconnected;
  List<VpnConfig> _listVpn = [];
  VpnConfig? _selectedVpn;
  String? scannedData;
  bool isScanned = false;
  bool _isLoading = false;
  String? _filePath;
  late OpenVPN engine;
  late var configContent;
  bool _isDisposed = false;
  @override
  void initState() {
    super.initState();
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        if (_isDisposed) return;
      },
      onVpnStageChanged: (data, raw) async {
        if (_isDisposed) return;
        print("VPN stage changed: $raw");
        // if (raw == 'CONNECTED' && !_hasExecutedApi) {
        //   _hasExecutedApi = true;
        //   await _handleVpnConnected();
        // }
      },
    );

    engine.initialize(
      groupIdentifier: "group.com.learnmode.lemo",
      providerBundleIdentifier: "com.learnmode.lemo.VPNExtension",
      localizedDescription: "Lemo",
      lastStage: (stage) {
        setState(() {
          //this.stage = stage.name;
        });
      },
      lastStatus: (status) {
        setState(() {
          //this.status = status;
        });
      },
    );
    //initVpn();
    _loadSavedPath();
  }

  @override
  void dispose() {
    _isDisposed = true;
    // Don't nullify callbacks - just mark as disposed
    // Keep the VPN connection active
    super.dispose();
  }

  Future<void> _handleVpnConnected() async {
    if (_isDisposed) return;
    setState(() => _isLoading = true);
    final learningModeProvider = Provider.of<LearningModeProvider>(
      context,
      listen: false,
    );
    final prefs = await SharedPreferences.getInstance();

    // Check if scannedData is null or empty
    if (scannedData == null || scannedData!.isEmpty) {
      _showInvalidQrSnackBar();
      setState(() => _isLoading = false);
      return;
    }

    try {
      final Map<String, dynamic> jsonData = json.decode(scannedData!);
      String id = jsonData['_id'];
      String schoolName = jsonData['school_name'];
      DateTime createdAt = DateTime.parse(jsonData['createdAt']);
      DateTime updatedAt = DateTime.parse(jsonData['updatedAt']);
      DateTime endTime = DateTime.parse(jsonData['end_time']);
      DateTime startTime = DateTime.parse(jsonData['start_time']);
      DateTime currentTime = DateTime.now();

      var userId = prefs.getString('dashboardUserId');
      var schoolId = prefs.getString('dashboardSchoolId');
      var token = prefs.getString('token');
      var sessionId = prefs.getString('sessionId');

      // Check if any required fields are null
      if (id == "" ||
          schoolName == "" ||
          createdAt == "" ||
          updatedAt == "" ||
          endTime == "" ||
          startTime == "" ||
          userId == "" ||
          schoolId == "" ||
          token == "") {
        print("Data null found");
        _showInvalidQrSnackBar();
        setState(() => _isLoading = false);
        return;
      }

      try {
        if (learningModeProvider.isLearningModeActive) {
          print(
            "Ending session IsLearningMode: ${learningModeProvider.isLearningModeActive}",
          );
          // Ending session
          var res = await _qrRepository.endingSession(
            token!,
            currentTime.toIso8601String(),
            "ended",
            isEarlyLeaveByTimeOnly(
              currentTime.toIso8601String(),
              endTime.toIso8601String(),
            ),
            sessionId!,
          );
          await prefs.remove('sessionId');
          log("Ending Session: $res");
        } else {
          // Starting session
          print(
            "Create session IsLearningMode: ${learningModeProvider.isLearningModeActive}",
          );
          var res = await _qrRepository.createSession(
            token!,
            userId!,
            schoolId!,
            currentTime.toIso8601String(),
            jsonData['end_time'],
            "in_progress",
            isTimeLate(
              currentTime.toIso8601String(),
              startTime.toIso8601String(),
            ),
            false,
          );
          log("Created Session: $res");
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
            scannedData = null;
            isScanned = false;
          });

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Dashboardscreen()),
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        log("Error during API call: $e");
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      log("Error parsing QR data: $e");
      _showInvalidQrSnackBar();
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Helper method to show SnackBar
  void _showInvalidQrSnackBar() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid QR code'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Retrieve file path from SharedPreferences
  Future<String?> getFilePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('downloaded_file_path');
  }

  Future<void> _loadSavedPath() async {
    final path = await getFilePath();
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        setState(() => _filePath = path);
        await initVpn(); // Load VPN config on startup if file exists
      } else {
        setState(() => _filePath = null);
      }
    }
  }

  // Your previous initVpn method, modified to use File
  Future<void> initVpn() async {
    final path = await getFilePath();
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        try {
          configContent = await file.readAsString();
        } catch (e) {
          (print('Error reading OVPN file: $e'));
        }
      } else {
        print('File does not exist at: $path');
      }
    } else {
      print('No file path available, download required');
    }
  }

  Future<void> initPlatformState() async {
    if (_isDisposed) return;
    engine.connect(
      configContent,
      "Demo",
      username: 'xwing',
      password: 'fender92',
      certIsRequired: true,
    );
    if (!mounted) return;
  }

  void _connectVpn() async {
    initPlatformState();
  }

  void _disconnectVpn() async {
    engine.disconnect();
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
          MobileScanner(onDetect: onDetect),
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
    final learningModeProvider = Provider.of<LearningModeProvider>(
      context,
      listen: false,
    );
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
              //Here it goes to main vpn connection part when user tap the buttons those code runs
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });

                //create preference instance to store value in key value pair
                final prefs = await SharedPreferences.getInstance();
                //Perse data string to individual string from qr code scanner data user scan qr and the data parse here
                final Map<String, dynamic> jsonData = json.decode(scannedData!);
                // Parse data in json format and Assign to individual variables
                String id = jsonData['_id'];
                String schoolName = jsonData['school_name'];
                DateTime createdAt = DateTime.parse(jsonData['createdAt']);
                DateTime updatedAt = DateTime.parse(jsonData['updatedAt']);
                DateTime endTime = DateTime.parse(jsonData['end_time']);
                DateTime startTime = DateTime.parse(jsonData['start_time']);

                // Get current time to start and end time
                DateTime currentTime = DateTime.now();
                //Get userid,schoolid,tokenand lateComein Flag from shared preference
                var userId = prefs.getString('dashboardUserId');
                var schoolId = prefs.getString('dashboardSchoolId');
                var token = prefs.getString('token');
                var sessionId = prefs.getString('sessionId');
                var lateComeIn = prefs.getBool('lateUse');

                //log to print all info make sure that it work perfectly
                log(userId!);
                log(schoolId!);
                log(currentTime.toIso8601String());
                log(id);
                log(schoolName);
                log("Created Att: ${createdAt}");
                log("${updatedAt}");
                log("end time: ${endTime.toIso8601String()}");
                log("Current time: ${currentTime.toIso8601String()}");
                log("${startTime}");
                log("${currentTime.isBefore(endTime)}");
                log(
                  "Is early Time: ${isEarlyLeaveByTimeOnly(currentTime.toIso8601String(), endTime.toIso8601String())}",
                );

                if (learningModeProvider.isLearningModeActive) {
                  _disconnectVpn();
                  await _handleVpnConnected();
                  learningModeProvider.stopLearningMode();
                  learningModeProvider.resetLearningMode();
                } else {
                  _connectVpn();
                  await _handleVpnConnected();
                  learningModeProvider.startLearningMode();
                }
              },
              //main bottom sheet button to handle operations
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
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
                child:
                    _isLoading
                        ? Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                        : Center(
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

  bool isEarlyLeaveByTimeOnly(String currentIso, String endIso) {
    try {
      DateTime currentUtc = DateTime.parse(
        currentIso,
      ).toUtc().add(const Duration(hours: 6));
      DateTime endUtc = DateTime.parse(
        endIso,
      ).toUtc().add(const Duration(hours: 6));

      // Extract only the time portion
      int currentInSeconds =
          currentUtc.hour * 3600 + currentUtc.minute * 60 + currentUtc.second;
      int endInSeconds =
          endUtc.hour * 3600 + endUtc.minute * 60 + endUtc.second;

      return currentInSeconds < endInSeconds;
    } catch (e) {
      print("Error comparing times: $e");
      return false;
    }
  }

  bool isTimeLate(String firstTimestamp, String secondTimestamp) {
    try {
      DateTime firstTimeUtc = DateTime.parse(firstTimestamp).toUtc();
      DateTime secondTimeUtc = DateTime.parse(secondTimestamp).toUtc();

      // Convert to Bangladesh time (UTC+6)
      DateTime firstTimeBst = firstTimeUtc.add(const Duration(hours: 6));
      DateTime secondTimeBst = secondTimeUtc.add(const Duration(hours: 6));

      // Get total seconds since midnight
      int firstTotalSeconds =
          firstTimeBst.hour * 3600 +
          firstTimeBst.minute * 60 +
          firstTimeBst.second;
      int secondTotalSeconds =
          secondTimeBst.hour * 3600 +
          secondTimeBst.minute * 60 +
          secondTimeBst.second;

      return firstTotalSeconds > secondTotalSeconds;
    } catch (e) {
      print('Error parsing timestamps: $e');
      return false;
    }
  }
}
