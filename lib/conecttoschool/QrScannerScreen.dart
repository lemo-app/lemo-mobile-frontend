// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../dashboard/DashboardScreen.dart';
// import '../models/vpn_config.dart';
// import '../provider/learningmode_provider.dart';
// import '../repositories/qr_repository.dart';
// import '../services/vpn_engine.dart';
// import '../utils/AlertDiaglogs.dart';
// import 'package:openvpn_flutter/openvpn_flutter.dart';
//
// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({super.key});
//
//   @override
//   State<QRScannerScreen> createState() => _QRScannerScreenState();
// }
//
// class _QRScannerScreenState extends State<QRScannerScreen> {
//   final QrRepository _qrRepository = QrRepository();
//   //String _vpnState = VpnEngine.vpnDisconnected;
//   List<VpnConfig> _listVpn = [];
//   VpnConfig? _selectedVpn;
//   String? scannedData;
//   bool isScanned = false;
//   bool _isLoading = false;
//   String? _filePath;
//   late OpenVPN engine;
//   late var configContent;
//   bool _isDisposed = false;
//   @override
//   void initState() {
//     super.initState();
//     engine = OpenVPN(
//       onVpnStatusChanged: (data) {
//         if (_isDisposed) return;
//       },
//       onVpnStageChanged: (data, raw) async {
//         if (_isDisposed) return;
//         print("VPN stage changed: $raw");
//         // if (raw == 'CONNECTED' && !_hasExecutedApi) {
//         //   _hasExecutedApi = true;
//         //   await _handleVpnConnected();
//         // }
//       },
//     );
//
//     engine.initialize(
//       groupIdentifier: "group.com.learnmode.lemo",
//       providerBundleIdentifier: "com.learnmode.lemo.VPNExtension",
//       localizedDescription: "Lemo",
//       lastStage: (stage) {
//         setState(() {
//           //this.stage = stage.name;
//         });
//       },
//       lastStatus: (status) {
//         setState(() {
//           //this.status = status;
//         });
//       },
//     );
//     //initVpn();
//     _loadSavedPath();
//   }
//
//   @override
//   void dispose() {
//     _isDisposed = true;
//     // Don't nullify callbacks - just mark as disposed
//     // Keep the VPN connection active
//     super.dispose();
//   }
//
//   Future<void> _handleVpnConnected() async {
//     if (_isDisposed) return;
//     setState(() => _isLoading = true);
//     final learningModeProvider = Provider.of<LearningModeProvider>(
//       context,
//       listen: false,
//     );
//     final prefs = await SharedPreferences.getInstance();
//
//     // Check if scannedData is null or empty
//     if (scannedData == null || scannedData!.isEmpty) {
//       _showInvalidQrSnackBar();
//       setState(() => _isLoading = false);
//       return;
//     }
//
//     try {
//       final Map<String, dynamic> jsonData = json.decode(scannedData!);
//       String id = jsonData['_id'];
//       String schoolName = jsonData['school_name'];
//       DateTime createdAt = DateTime.parse(jsonData['createdAt']);
//       DateTime updatedAt = DateTime.parse(jsonData['updatedAt']);
//       DateTime endTime = DateTime.parse(jsonData['end_time']);
//       DateTime startTime = DateTime.parse(jsonData['start_time']);
//       DateTime currentTime = DateTime.now();
//
//       var userId = prefs.getString('dashboardUserId');
//       var schoolId = prefs.getString('dashboardSchoolId');
//       var token = prefs.getString('token');
//       var sessionId = prefs.getString('sessionId');
//
//       // Check if any required fields are null
//       if (id == "" ||
//           schoolName == "" ||
//           createdAt == "" ||
//           updatedAt == "" ||
//           endTime == "" ||
//           startTime == "" ||
//           userId == "" ||
//           schoolId == "" ||
//           token == "") {
//         print("Data null found");
//         _showInvalidQrSnackBar();
//         setState(() => _isLoading = false);
//         return;
//       }
//
//       try {
//         if (learningModeProvider.isLearningModeActive) {
//           print(
//             "Ending session IsLearningMode: ${learningModeProvider.isLearningModeActive}",
//           );
//           // Ending session
//           var res = await _qrRepository.endingSession(
//             token!,
//             currentTime.toIso8601String(),
//             "ended",
//             isEarlyLeaveByTimeOnly(
//               currentTime.toIso8601String(),
//               endTime.toIso8601String(),
//             ),
//             sessionId!,
//           );
//           await prefs.remove('sessionId');
//           log("Ending Session: $res");
//         } else {
//           // Starting session
//           print(
//             "Create session IsLearningMode: ${learningModeProvider.isLearningModeActive}",
//           );
//           var res = await _qrRepository.createSession(
//             token!,
//             userId!,
//             schoolId!,
//             currentTime.toIso8601String(),
//             jsonData['end_time'],
//             "in_progress",
//             isTimeLate(
//               currentTime.toIso8601String(),
//               startTime.toIso8601String(),
//             ),
//             false,
//           );
//           log("Created Session: $res");
//         }
//
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//             scannedData = null;
//             isScanned = false;
//           });
//
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => const Dashboardscreen()),
//             (Route<dynamic> route) => false,
//           );
//         }
//       } catch (e) {
//         log("Error during API call: $e");
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     } catch (e) {
//       log("Error parsing QR data: $e");
//       _showInvalidQrSnackBar();
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   // Helper method to show SnackBar
//   void _showInvalidQrSnackBar() {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid QR code'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }
//
//   // Retrieve file path from SharedPreferences
//   Future<String?> getFilePath() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('downloaded_file_path');
//   }
//
//   Future<void> _loadSavedPath() async {
//     final path = await getFilePath();
//     if (path != null) {
//       final file = File(path);
//       if (await file.exists()) {
//         setState(() => _filePath = path);
//         await initVpn(); // Load VPN config on startup if file exists
//       } else {
//         setState(() => _filePath = null);
//       }
//     }
//   }
//
//   // Your previous initVpn method, modified to use File
//   Future<void> initVpn() async {
//     final path = await getFilePath();
//     if (path != null) {
//       final file = File(path);
//       if (await file.exists()) {
//         try {
//           configContent = await file.readAsString();
//         } catch (e) {
//           (print('Error reading OVPN file: $e'));
//         }
//       } else {
//         print('File does not exist at: $path');
//       }
//     } else {
//       print('No file path available, download required');
//     }
//   }
//
//   Future<void> initPlatformState() async {
//     if (_isDisposed) return;
//     engine.connect(
//       configContent,
//       "Demo",
//       username: 'xwing',
//       password: 'fender92',
//       certIsRequired: true,
//     );
//     if (!mounted) return;
//   }
//
//   void _connectVpn() async {
//     initPlatformState();
//   }
//
//   void _disconnectVpn() async {
//     engine.disconnect();
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
//           MobileScanner(onDetect: onDetect),
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
//   //Bottom nave for navigate to dashboard and show school qr result
//   Widget _buildBottomNavigation() {
//     final learningModeProvider = Provider.of<LearningModeProvider>(
//       context,
//       listen: false,
//     );
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         width: double.infinity,
//         height: 150, // Increased height for better space
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 30),
//             GestureDetector(
//               //Here it goes to main vpn connection part when user tap the buttons those code runs
//               onTap: () async {
//                 setState(() {
//                   _isLoading = true;
//                 });
//
//                 //create preference instance to store value in key value pair
//                 final prefs = await SharedPreferences.getInstance();
//                 //Perse data string to individual string from qr code scanner data user scan qr and the data parse here
//                 final Map<String, dynamic> jsonData = json.decode(scannedData!);
//                 // Parse data in json format and Assign to individual variables
//                 String id = jsonData['_id'];
//                 String schoolName = jsonData['school_name'];
//                 DateTime createdAt = DateTime.parse(jsonData['createdAt']);
//                 DateTime updatedAt = DateTime.parse(jsonData['updatedAt']);
//                 DateTime endTime = DateTime.parse(jsonData['end_time']);
//                 DateTime startTime = DateTime.parse(jsonData['start_time']);
//
//                 // Get current time to start and end time
//                 DateTime currentTime = DateTime.now();
//                 //Get userid,schoolid,tokenand lateComein Flag from shared preference
//                 var userId = prefs.getString('dashboardUserId');
//                 var schoolId = prefs.getString('dashboardSchoolId');
//                 var token = prefs.getString('token');
//                 var sessionId = prefs.getString('sessionId');
//                 var lateComeIn = prefs.getBool('lateUse');
//
//                 //log to print all info make sure that it work perfectly
//                 log(userId!);
//                 log(schoolId!);
//                 log(currentTime.toIso8601String());
//                 log(id);
//                 log(schoolName);
//                 log("Created Att: ${createdAt}");
//                 log("${updatedAt}");
//                 log("end time: ${endTime.toIso8601String()}");
//                 log("Current time: ${currentTime.toIso8601String()}");
//                 log("${startTime}");
//                 log("${currentTime.isBefore(endTime)}");
//                 log(
//                   "Is early Time: ${isEarlyLeaveByTimeOnly(currentTime.toIso8601String(), endTime.toIso8601String())}",
//                 );
//
//                 if (learningModeProvider.isLearningModeActive) {
//                   _disconnectVpn();
//                   await _handleVpnConnected();
//                   learningModeProvider.stopLearningMode();
//                   learningModeProvider.resetLearningMode();
//                 } else {
//                   _connectVpn();
//                   await _handleVpnConnected();
//                   learningModeProvider.startLearningMode();
//                 }
//               },
//               //main bottom sheet button to handle operations
//               child: Container(
//                 width: 320,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 40,
//                   vertical: 15,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.blue, // Button background color
//                   borderRadius: BorderRadius.circular(12), // Rounded corners
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.blue.withOpacity(0.5),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(0, 3), // Shadow effect
//                     ),
//                   ],
//                 ),
//                 child:
//                     _isLoading
//                         ? Center(
//                           child: SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           ),
//                         )
//                         : Center(
//                           child: const Text(
//                             'Next',
//                             style: TextStyle(
//                               color: Colors.white, // Text color
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   bool isEarlyLeaveByTimeOnly(String currentIso, String endIso) {
//     try {
//       DateTime currentUtc = DateTime.parse(
//         currentIso,
//       ).toUtc().add(const Duration(hours: 6));
//       DateTime endUtc = DateTime.parse(
//         endIso,
//       ).toUtc().add(const Duration(hours: 6));
//
//       // Extract only the time portion
//       int currentInSeconds =
//           currentUtc.hour * 3600 + currentUtc.minute * 60 + currentUtc.second;
//       int endInSeconds =
//           endUtc.hour * 3600 + endUtc.minute * 60 + endUtc.second;
//
//       return currentInSeconds < endInSeconds;
//     } catch (e) {
//       print("Error comparing times: $e");
//       return false;
//     }
//   }
//
//   bool isTimeLate(String firstTimestamp, String secondTimestamp) {
//     try {
//       DateTime firstTimeUtc = DateTime.parse(firstTimestamp).toUtc();
//       DateTime secondTimeUtc = DateTime.parse(secondTimestamp).toUtc();
//
//       // Convert to Bangladesh time (UTC+6)
//       DateTime firstTimeBst = firstTimeUtc.add(const Duration(hours: 6));
//       DateTime secondTimeBst = secondTimeUtc.add(const Duration(hours: 6));
//
//       // Get total seconds since midnight
//       int firstTotalSeconds =
//           firstTimeBst.hour * 3600 +
//           firstTimeBst.minute * 60 +
//           firstTimeBst.second;
//       int secondTotalSeconds =
//           secondTimeBst.hour * 3600 +
//           secondTimeBst.minute * 60 +
//           secondTimeBst.second;
//
//       return firstTotalSeconds > secondTotalSeconds;
//     } catch (e) {
//       print('Error parsing timestamps: $e');
//       return false;
//     }
//   }
// }

//2nd code

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../dashboard/DashboardScreen.dart';
// import '../models/vpn_config.dart';
// import '../provider/learningmode_provider.dart';
// import '../repositories/qr_repository.dart';
// import '../services/vpn_engine.dart';
// import 'package:openvpn_flutter/openvpn_flutter.dart';
//
// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({super.key});
//
//   @override
//   State<QRScannerScreen> createState() => _QRScannerScreenState();
// }
//
// class _QRScannerScreenState extends State<QRScannerScreen> {
//   final QrRepository _qrRepository = QrRepository();
//   List<VpnConfig> _listVpn = [];
//   VpnConfig? _selectedVpn;
//   String? scannedData;
//   bool isScanned = false;
//   bool _isLoading = false;
//   String? _filePath;
//   late OpenVPN engine;
//   late var configContent;
//   bool _isDisposed = false;
//   bool _isVpnConnected = false; // Track VPN connection status
//   final MobileScannerController _scannerController = MobileScannerController();
//
//   @override
//   void initState() {
//     super.initState();
//     engine = OpenVPN(
//       onVpnStatusChanged: (data) {
//         if (_isDisposed) return;
//         setState(() {}); // Update UI if needed
//       },
//       onVpnStageChanged: (data, raw) {
//         if (_isDisposed) return;
//         log("VPN stage changed: $raw");
//         setState(() {
//           if (raw == "connected") {
//             _isVpnConnected = true; // VPN is connected
//           } else if (raw == "disconnected" || raw == "error") {
//             _isVpnConnected = false; // VPN is not connected
//           }
//         });
//       },
//     );
//
//     engine.initialize(
//       groupIdentifier: "group.com.learnmode.lemo",
//       providerBundleIdentifier: "com.learnmode.lemo.VPNExtension",
//       localizedDescription: "Lemo",
//       lastStage: (stage) {
//         setState(() {});
//       },
//       lastStatus: (status) {
//         setState(() {});
//       },
//     );
//     _loadSavedPath();
//
// // Debug SharedPreferences on init
//     SharedPreferences.getInstance().then((prefs) {
//       _debugSharedPreferences(prefs);
//     });
//   }
//
//   @override
//   void dispose() {
//     _isDisposed = true;
//     _scannerController.dispose();
//     super.dispose();
//   }
//
//   bool _validateJsonFields(Map<String, dynamic> jsonData) {
//     final requiredFields = [
//       '_id',
//       'school_name',
//       'createdAt',
//       'updatedAt',
//       'end_time',
//       'start_time'
//     ];
//     for (var field in requiredFields) {
//       if (!jsonData.containsKey(field) ||
//           jsonData[field] == null ||
//           jsonData[field] == "") {
//         log("Missing or empty field: $field");
//         return false;
//       }
//     }
//     return true;
//   }
//
//   void _showMissingFieldSnackBar() {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('QR code missing required JSON fields'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }
//
//   void _debugSharedPreferences(SharedPreferences prefs) {
//     log("SharedPreferences Debug:");
//     log("dashboardUserId: ${prefs.getString('dashboardUserId')}");
//     log("dashboardSchoolId: ${prefs.getString('dashboardSchoolId')}");
//     log("token: ${prefs.getString('token')}");
//     log("sessionId: ${prefs.getString('sessionId')}");
//   }
//
//   void _showApiErrorSnackBar() {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Failed to process session. Please try again.'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }
//
//   Future<void> _handleVpnConnected() async {
//     if (_isDisposed) {
//       log("handleVpnConnected: Widget is disposed, aborting");
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       isScanned = true;
//     });
//
//     final learningModeProvider = Provider.of<LearningModeProvider>(
//       context,
//       listen: false,
//     );
//     final prefs = await SharedPreferences.getInstance();
//
// // Debug SharedPreferences
//     _debugSharedPreferences(prefs);
//
//     if (scannedData == null || scannedData!.isEmpty) {
//       log("handleVpnConnected: Scanned data is null or empty");
//       _showInvalidQrSnackBar();
//       setState(() {
//         _isLoading = false;
//         isScanned = false;
//       });
//       await _scannerController.start();
//       return;
//     }
//
//     try {
//       final Map<String, dynamic> jsonData = json.decode(scannedData!);
//       log("handleVpnConnected: Parsed JSON: $jsonData");
//
//       if (!_validateJsonFields(jsonData)) {
//         log("handleVpnConnected: JSON validation failed");
//         showWarningDialog(context);
//         setState(() {
//           _isLoading = false;
//           isScanned = false;
//         });
//         await _scannerController.start();
//         return;
//       }
//
// // Extract QR data
//       String id = jsonData['_id'];
//       String schoolName = jsonData['school_name'];
//       DateTime createdAt = DateTime.parse(jsonData['createdAt']);
//       DateTime updatedAt = DateTime.parse(jsonData['updatedAt']);
//       DateTime endTime = DateTime.parse(jsonData['end_time']);
//       DateTime startTime = DateTime.parse(jsonData['start_time']);
//       DateTime currentTime = DateTime.now();
//
// // Retrieve SharedPreferences data
//       var userId = prefs.getString('dashboardUserId');
//       var schoolId = prefs.getString('dashboardSchoolId');
//       var token = prefs.getString('token');
//       var sessionId = prefs.getString('sessionId');
//
//       log("handleVpnConnected: QR Data - id: $id, schoolName: $schoolName, schoolId: $schoolId");
//       log("handleVpnConnected: SharedPrefs - userId: $userId, schoolId: $schoolId, token: $token, sessionId: $sessionId");
//
// // Validate required fields
//       if (id.isEmpty ||
//           schoolName.isEmpty ||
//           userId == null ||
//           userId.isEmpty ||
//           schoolId == null ||
//           schoolId.isEmpty ||
//           token == null ||
//           token.isEmpty ||
//           (learningModeProvider.isLearningModeActive &&
//               (sessionId == null || sessionId.isEmpty))) {
//         log("handleVpnConnected: Missing required data");
//         _showInvalidQrSnackBar();
//         setState(() {
//           _isLoading = false;
//           isScanned = false;
//         });
//         await _scannerController.start();
//         return;
//       }
//
//       try {
//         dynamic res;
//         if (learningModeProvider.isLearningModeActive) {
//           log("handleVpnConnected: Ending session, isLearningMode: ${learningModeProvider.isLearningModeActive}");
//           res = await _qrRepository.endingSession(
//             token,
//             currentTime.toIso8601String(),
//             "ended",
//             isEarlyLeaveByTimeOnly(
//               currentTime.toIso8601String(),
//               endTime.toIso8601String(),
//             ),
//             sessionId!,
//           );
//           await prefs.remove('sessionId');
//           log("handleVpnConnected: Ending Session Response: $res");
//         } else {
//           log("handleVpnConnected: Creating session, isLearningMode: ${learningModeProvider.isLearningModeActive}");
//           res = await _qrRepository.createSession(
//             token,
//             userId,
//             schoolId,
//             currentTime.toIso8601String(),
//             jsonData['end_time'],
//             "in_progress",
//             isTimeLate(
//               currentTime.toIso8601String(),
//               startTime.toIso8601String(),
//             ),
//             false,
//           );
//           log("handleVpnConnected: Create Session Response: $res");
//         }
//
// // TODO: Adjust this based on your API's response structure
// // Example: If API returns {'success': true, 'data': {...}}, use res['success'] == true
//         if (res != null) {
//           if (mounted) {
//             setState(() {
//               _isLoading = false;
//               scannedData = null;
//               isScanned = false;
//             });
//
//             log("handleVpnConnected: Navigating to DashboardScreen");
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => const Dashboardscreen()),
//               (Route<dynamic> route) => false,
//             );
//           } else {
//             log("handleVpnConnected: Widget not mounted, skipping navigation");
//           }
//         } else {
//           log("handleVpnConnected: API response invalid: $res");
//           _showApiErrorSnackBar();
//           setState(() {
//             _isLoading = false;
//             isScanned = false;
//           });
//           await _scannerController.start();
//         }
//       } catch (e, stackTrace) {
//         log("handleVpnConnected: API call error: $e");
//         log("Stack trace: $stackTrace");
//         _showApiErrorSnackBar();
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//             isScanned = false;
//           });
//           await _scannerController.start();
//         }
//       }
//     } catch (e, stackTrace) {
//       log("handleVpnConnected: Error parsing QR data: $e");
//       log("Stack trace: $stackTrace");
//       _showInvalidQrSnackBar();
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//           isScanned = false;
//         });
//         await _scannerController.start();
//       }
//     }
//   }
//
//   void _showInvalidQrSnackBar() {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid QR code'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }
//
//   void _showVpnConnectionFailedSnackBar() {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('VPN connection failed'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }
//
//   Future<String?> getFilePath() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('downloaded_file_path');
//   }
//
//   Future<void> _loadSavedPath() async {
//     final path = await getFilePath();
//     if (path != null) {
//       final file = File(path);
//       if (await file.exists()) {
//         setState(() => _filePath = path);
//         await initVpn();
//       } else {
//         setState(() => _filePath = null);
//       }
//     }
//   }
//
//   Future<void> initVpn() async {
//     final path = await getFilePath();
//     if (path != null) {
//       final file = File(path);
//       if (await file.exists()) {
//         try {
//           configContent = await file.readAsString();
//         } catch (e) {
//           log('Error reading OVPN file: $e');
//         }
//       } else {
//         log('File does not exist at: $path');
//       }
//     } else {
//       log('No file path available, download required');
//     }
//   }
//
//   Future<void> _connectVpn() async {
//     if (_isDisposed) return;
//     try {
//       await initVpn(); // Ensure config is loaded
//       if (configContent != null) {
//         engine.connect(
//           configContent,
//           "Demo",
//           username: 'xwing',
//           password: 'fender92',
//           certIsRequired: true,
//         );
//       } else {
//         log("VPN config content is null");
//         throw Exception("VPN configuration not found");
//       }
//     } catch (e) {
//       log("Error connecting VPN: $e");
//       throw e;
//     }
//   }
//
//   Future<bool> _waitForVpnConnection({int timeoutSeconds = 10}) async {
//     int elapsedSeconds = 0;
//     const int pollingIntervalMs = 500;
//
//     while (elapsedSeconds < timeoutSeconds) {
//       if (_isVpnConnected) {
//         return true; // VPN is connected
//       }
//       await Future.delayed(Duration(milliseconds: pollingIntervalMs));
//       elapsedSeconds += (pollingIntervalMs ~/ 1000);
//     }
//     return false; // Timeout reached, VPN not connected
//   }
//
//   void _disconnectVpn() async {
//     engine.disconnect();
//   }
//
//   void onDetect(BarcodeCapture capture) async {
//     if (!isScanned && capture.barcodes.isNotEmpty) {
//       setState(() {
//         scannedData = capture.barcodes.first.rawValue;
//         isScanned = true;
//         _isLoading = true;
//       });
//
//       log("onDetect: Scanned QR data: $scannedData");
//
//       final learningModeProvider = Provider.of<LearningModeProvider>(
//         context,
//         listen: false,
//       );
//
//       try {
//         if (learningModeProvider.isLearningModeActive) {
// // Ending a session: Disconnect VPN and handle session
//           _disconnectVpn();
//           await _handleVpnConnected(); // Handle session ending
//           learningModeProvider.stopLearningMode();
//           learningModeProvider.resetLearningMode();
//         } else {
// // Starting a session: Connect VPN and wait for connection
//           await _connectVpn();
//           bool vpnConnected = await _waitForVpnConnection(timeoutSeconds: 10);
//           if (vpnConnected) {
//             await _handleVpnConnected(); // Handle session creation
//             learningModeProvider.startLearningMode();
//           } else {
//             _showVpnConnectionFailedSnackBar();
//             setState(() {
//               _isLoading = false;
//               scannedData = null;
//               isScanned = false;
//             });
//             await _scannerController.start();
//           }
//         }
//       } catch (e, stackTrace) {
//         log("onDetect: Error processing QR data: $e");
//         log("Stack trace: $stackTrace");
//         _showInvalidQrSnackBar();
//         setState(() {
//           _isLoading = false;
//           scannedData = null;
//           isScanned = false;
//         });
//         await _scannerController.start();
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           MobileScanner(
//             controller: _scannerController,
//             onDetect: onDetect,
//           ),
//           _buildScannerOverlay(),
//           if (_isLoading)
//             Center(
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 4,
//                 ),
//               ),
//             ),
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
//   void showWarningDialog(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.error_outline,
//                       size: 40,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Error!",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: isDarkMode ? Colors.white : Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             "Invalid Qr Code.",
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: isDarkMode ? Colors.white : Colors.black54,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           SizedBox(
//                             width: screenWidth * 0.25,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   isScanned = false;
//                                 });
//                                 Navigator.of(context).pop();
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 12),
//                               ),
//                               child: const Text(
//                                 "Okay",
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 16),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   bool isEarlyLeaveByTimeOnly(String currentIso, String endIso) {
//     try {
//       DateTime currentUtc =
//           DateTime.parse(currentIso).toUtc().add(const Duration(hours: 6));
//       DateTime endUtc =
//           DateTime.parse(endIso).toUtc().add(const Duration(hours: 6));
//
//       int currentInSeconds =
//           currentUtc.hour * 3600 + currentUtc.minute * 60 + currentUtc.second;
//       int endInSeconds =
//           endUtc.hour * 3600 + endUtc.minute * 60 + endUtc.second;
//
//       return currentInSeconds < endInSeconds;
//     } catch (e) {
//       log("Error comparing times: $e");
//       return false;
//     }
//   }
//
//   bool isTimeLate(String firstTimestamp, String secondTimestamp) {
//     try {
//       DateTime firstTimeUtc = DateTime.parse(firstTimestamp).toUtc();
//       DateTime secondTimeUtc = DateTime.parse(secondTimestamp).toUtc();
//
//       DateTime firstTimeBst = firstTimeUtc.add(const Duration(hours: 6));
//       DateTime secondTimeBst = secondTimeUtc.add(const Duration(hours: 6));
//
//       int firstTotalSeconds = firstTimeBst.hour * 3600 +
//           firstTimeBst.minute * 60 +
//           firstTimeBst.second;
//       int secondTotalSeconds = secondTimeBst.hour * 3600 +
//           secondTimeBst.minute * 60 +
//           secondTimeBst.second;
//
//       return firstTotalSeconds > secondTotalSeconds;
//     } catch (e) {
//       log('Error parsing timestamps: $e');
//       return false;
//     }
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
import 'package:openvpn_flutter/openvpn_flutter.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final QrRepository _qrRepository = QrRepository();
  List<VpnConfig> _listVpn = [];
  VpnConfig? _selectedVpn;
  String? scannedData;
  bool isScanned = false;
  bool _isLoading = false;
  String? _filePath;
  late OpenVPN engine;
  late var configContent;
  bool _isDisposed = false;
  bool _isVpnConnected = false;
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        if (_isDisposed) return;
        log("onVpnStatusChanged: $data");
        setState(() {});
      },
      onVpnStageChanged: (data, raw) {
        if (_isDisposed) return;
        log("onVpnStageChanged: $raw");
        setState(() {
          if (raw == "connected") {
            _isVpnConnected = true;
          } else if (raw == "disconnected" || raw == "error") {
            _isVpnConnected = false;
          }
        });
      },
    );

    engine.initialize(
      groupIdentifier: "group.com.learnmode.lemo",
      providerBundleIdentifier: "com.learnmode.lemo.VPNExtension",
      localizedDescription: "Lemo",
      lastStage: (stage) {
        log("lastStage: $stage");
        setState(() {});
      },
      lastStatus: (status) {
        log("lastStatus: $status");
        setState(() {});
      },
    );
    _loadSavedPath();

    SharedPreferences.getInstance().then((prefs) {
      _debugSharedPreferences(prefs);
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scannerController.dispose();
    super.dispose();
  }

  bool _validateJsonFields(Map<String, dynamic> jsonData) {
    final requiredFields = [
      '_id',
      'school_name',
      'created_at',
      'updated_at',
      'start_time',
      'end_time'
    ];
    for (var field in requiredFields) {
      if (!jsonData.containsKey(field) ||
          jsonData[field] == null ||
          jsonData[field] == "") {
        log("Missing or empty field: $field");
        return false;
      }
    }
    return true;
  }

  void _showMissingFieldSnackBar() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR code missing required JSON fields'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _debugSharedPreferences(SharedPreferences prefs) {
    log("SharedPreferences Debug:");
    log("dashboardUserId: ${prefs.getString('dashboardUserId')}");
    log("dashboardSchoolId: ${prefs.getString('dashboardSchoolId')}");
    log("token: ${prefs.getString('token')}");
    log("sessionId: ${prefs.getString('sessionId')}");
  }

  void _showApiErrorSnackBar() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to process session. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleVpnConnected() async {
    if (_isDisposed) {
      log("handleVpnConnected: Widget is disposed, aborting");
      return;
    }

    setState(() {
      _isLoading = true;
      isScanned = true;
    });

    final learningModeProvider = Provider.of<LearningModeProvider>(
      context,
      listen: false,
    );
    final prefs = await SharedPreferences.getInstance();

    _debugSharedPreferences(prefs);

    // if (scannedData == null || scannedData!.isEmpty) {
    //   log("handleVpnConnected: Scanned data is null or empty");
    //   _showInvalidQrSnackBar();
    //   setState(() {
    //     _isLoading = false;
    //     isScanned = false;
    //   });
    //   await _scannerController.start();
    //   return;
    // }

    try {
      final Map<String, dynamic> jsonData = json.decode(scannedData!);
      log("handleVpnConnected: Parsed JSON: $jsonData");

      if (!_validateJsonFields(jsonData)) {
        log("handleVpnConnected: JSON validation failed");
        showWarningDialog(context);
        setState(() {
          _isLoading = false;
          isScanned = false;
        });
        await _scannerController.start();
        return;
      }

      String id = jsonData['_id'];
      String schoolName = jsonData['school_name'];
      DateTime createdAt = DateTime.parse(jsonData['created_at']);
      DateTime updatedAt = DateTime.parse(jsonData['updated_at']);
      DateTime endTime = DateTime.parse(jsonData['end_time']);
      DateTime startTime = DateTime.parse(jsonData['start_time']);
      DateTime currentTime = DateTime.now();

      var userId = prefs.getString('dashboardUserId');
      var schoolId = prefs.getString('dashboardSchoolId');
      var token = prefs.getString('token');
      var sessionId = prefs.getString('sessionId');

      log("handleVpnConnected: QR Data - id: $id, schoolName: $schoolName, schoolId: $schoolId");
      log("handleVpnConnected: SharedPrefs - userId: $userId, schoolId: $schoolId, token: $token, sessionId: $sessionId");

      if (id.isEmpty ||
          schoolName.isEmpty ||
          userId == null ||
          userId.isEmpty ||
          schoolId == null ||
          schoolId.isEmpty ||
          token == null ||
          token.isEmpty ||
          (learningModeProvider.isLearningModeActive &&
              (sessionId == null || sessionId.isEmpty))) {
        log("handleVpnConnected: Missing required data");
        _showInvalidQrSnackBar();
        setState(() {
          _isLoading = false;
          isScanned = false;
        });
        await _scannerController.start();
        return;
      }

      try {
        dynamic res;
        if (learningModeProvider.isLearningModeActive) {
          log("handleVpnConnected: Ending session, isLearningMode: ${learningModeProvider.isLearningModeActive}");
          res = await _qrRepository.endingSession(
            token,
            currentTime.toIso8601String(),
            "ended",
            isEarlyLeaveByTimeOnly(
              currentTime.toIso8601String(),
              endTime.toIso8601String(),
            ),
            sessionId!,
          );
          await prefs.remove('sessionId');
          log("handleVpnConnected: Ending Session Response: $res");
        } else {
          log("handleVpnConnected: Creating session, isLearningMode: ${learningModeProvider.isLearningModeActive}");
          res = await _qrRepository.createSession(
            token,
            userId,
            schoolId,
            currentTime.toIso8601String(),
            jsonData['end_time'],
            "in_progress",
            isTimeLate(
              currentTime.toIso8601String(),
              startTime.toIso8601String(),
            ),
            false,
          );
          log("handleVpnConnected: Create Session Response: $res");
        }

// TODO: Adjust based on your API's response structure
        if (res != null) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              scannedData = null;
              isScanned = false;
            });

            log("handleVpnConnected: Navigating to DashboardScreen");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Dashboardscreen()),
              (Route<dynamic> route) => false,
            );
          } else {
            log("handleVpnConnected: Widget not mounted, skipping navigation");
          }
        } else {
          log("handleVpnConnected: API response invalid: $res");
          _showApiErrorSnackBar();
          setState(() {
            _isLoading = false;
            isScanned = false;
          });
          await _scannerController.start();
        }
      } catch (e, stackTrace) {
        log("handleVpnConnected: API call error: $e");
        log("Stack trace: $stackTrace");
        _showApiErrorSnackBar();
        if (mounted) {
          setState(() {
            _isLoading = false;
            isScanned = false;
          });
          await _scannerController.start();
        }
      }
    } catch (e, stackTrace) {
      log("handleVpnConnected: Error parsing QR data: $e");
      log("Stack trace: $stackTrace");
      _showInvalidQrSnackBar();
      if (mounted) {
        setState(() {
          _isLoading = false;
          isScanned = false;
        });
        await _scannerController.start();
      }
    }
  }

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

  void _showVpnConnectionFailedSnackBar() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('VPN connection failed. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

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
        await initVpn();
      } else {
        setState(() => _filePath = null);
        log("loadSavedPath: File does not exist at $path");
      }
    } else {
      log("loadSavedPath: No file path found in SharedPreferences");
    }
  }

  Future<void> initVpn() async {
    final path = await getFilePath();
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        try {
          configContent = await file.readAsString();
          log("initVpn: Successfully loaded VPN config from $path");
        } catch (e) {
          log('initVpn: Error reading OVPN file: $e');
          configContent = null;
        }
      } else {
        log('initVpn: File does not exist at: $path');
        configContent = null;
      }
    } else {
      log('initVpn: No file path available, download required');
      configContent = null;
    }
  }

  Future<void> _connectVpn() async {
    if (_isDisposed) {
      log("connectVpn: Widget is disposed, aborting");
      return;
    }
    try {
      await initVpn();
      if (configContent != null && configContent.isNotEmpty) {
        log("connectVpn: Attempting to connect VPN with config");
        engine.connect(
          configContent,
          "Demo",
          username: 'xwing',
          password: 'fender92',
          certIsRequired: true,
        );
      } else {
        log("connectVpn: VPN config content is null or empty");
        throw Exception("VPN configuration not found or invalid");
      }
    } catch (e, stackTrace) {
      log("connectVpn: Error connecting VPN: $e");
      log("Stack trace: $stackTrace");
      throw e;
    }
  }

  Future<bool> _waitForVpnConnection({int timeoutSeconds = 10}) async {
    try {
      int elapsedSeconds = 0;
      const int pollingIntervalMs = 500;
      final startTime = DateTime.now();

      log("waitForVpnConnection: Waiting for VPN connection (timeout: $timeoutSeconds seconds)");
      while (elapsedSeconds < timeoutSeconds) {
        if (_isVpnConnected) {
          log("waitForVpnConnection: VPN connected successfully after ${DateTime.now().difference(startTime).inSeconds} seconds");
          return true;
        }
        await Future.delayed(Duration(milliseconds: pollingIntervalMs));
        elapsedSeconds = DateTime.now().difference(startTime).inSeconds;
      }
      log("waitForVpnConnection: VPN connection timed out after $timeoutSeconds seconds");
      return false;
    } catch (e, stackTrace) {
      log("waitForVpnConnection: Unexpected error: $e");
      log("Stack trace: $stackTrace");
      return false;
    }
  }

  void _disconnectVpn() async {
    try {
      log("disconnectVpn: Disconnecting VPN");
      engine.disconnect();
    } catch (e, stackTrace) {
      log("disconnectVpn: Error disconnecting VPN: $e");
      log("Stack trace: $stackTrace");
    }
  }

  void onDetect(BarcodeCapture capture) async {
    if (!isScanned && capture.barcodes.isNotEmpty) {
      log("onDetect: Starting QR scan processing");
      await _scannerController.stop();
      setState(() {
        scannedData = capture.barcodes.first.rawValue;
        isScanned = true;
        _isLoading = true;
      });

      log("onDetect: Scanned QR data: $scannedData");

      final learningModeProvider = Provider.of<LearningModeProvider>(
        context,
        listen: false,
      );

      final Map<String, dynamic> jsonData = json.decode(scannedData!);
      log("handleVpnConnected: Parsed JSON: $jsonData");

      if (!_validateJsonFields(jsonData)) {
        log("handleVpnConnected: JSON validation failed");
        showWarningDialog(context);
        setState(() {
          _isLoading = false;
          isScanned = false;
        });
        await _scannerController.start();
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      String id = jsonData['_id'];
      String schoolName = jsonData['school_name'];
      DateTime createdAt = DateTime.parse(jsonData['created_at']);
      DateTime updatedAt = DateTime.parse(jsonData['updated_at']);
      DateTime endTime = DateTime.parse(jsonData['end_time']);
      DateTime startTime = DateTime.parse(jsonData['start_time']);
      DateTime currentTime = DateTime.now();

      var userId = prefs.getString('dashboardUserId');
      var schoolId = prefs.getString('dashboardSchoolId');
      var token = prefs.getString('token');
      var sessionId = prefs.getString('sessionId');

      log("handleVpnConnected: QR Data - id: $id, schoolName: $schoolName, schoolId: $schoolId, created_at: $createdAt, updated_at: $updatedAt, start_time: $startTime, end_time: $endTime");
      log("handleVpnConnected: SharedPrefs - userId: $userId, schoolId: $schoolId, token: $token, sessionId: $sessionId");

      // if (id.isEmpty ||
      //     schoolName.isEmpty ||
      //     userId == null ||
      //     userId.isEmpty ||
      //     schoolId == null ||
      //     schoolId.isEmpty ||
      //     token == null ||
      //     token.isEmpty ||
      //     (learningModeProvider.isLearningModeActive &&
      //         (sessionId == null || sessionId.isEmpty))) {
      //   log("handleVpnConnected: Missing required data");
      //   showWarningDialog(context);
      //   setState(() {
      //     _isLoading = false;
      //     isScanned = false;
      //   });
      //   await _scannerController.start();
      //   return;
      // }

      try {
        if (learningModeProvider.isLearningModeActive) {
          log("onDetect: Ending session");
          _disconnectVpn();
          await _handleVpnConnected();
          learningModeProvider.stopLearningMode();
          learningModeProvider.resetLearningMode();
        } else {
          log("onDetect: Starting session");
          try {
            await _connectVpn();
            bool vpnConnected = await _waitForVpnConnection(timeoutSeconds: 10);
            if (vpnConnected) {
              log("onDetect: VPN connected, proceeding to handle session");
              await _handleVpnConnected();
              learningModeProvider.startLearningMode();
            } else {
              log("onDetect: VPN connection failed or timed out");
              _resetStateOnVpnFailure();
            }
          } catch (e, stackTrace) {
            log("onDetect: VPN connection error: $e");
            log("Stack trace: $stackTrace");
            _resetStateOnVpnFailure();
          }
        }
      } catch (e, stackTrace) {
        log("onDetect: Unexpected error processing QR data: $e");
        log("Stack trace: $stackTrace");
        _resetStateOnError();
      }
    }
  }

  void _resetStateOnVpnFailure() async {
    log("resetStateOnVpnFailure: Resetting state due to VPN failure");
    if (mounted) {
      _showVpnConnectionFailedSnackBar();
      setState(() {
        _isLoading = false;
        scannedData = null;
        isScanned = false;
      });
      try {
        await _scannerController.start();
        log("resetStateOnVpnFailure: Scanner restarted");
      } catch (e) {
        log("resetStateOnVpnFailure: Error restarting scanner: $e");
      }
    } else {
      log("resetStateOnVpnFailure: Widget not mounted, attempting to restart scanner");
      try {
        await _scannerController.start();
        log("resetStateOnVpnFailure: Scanner restarted (unmounted)");
      } catch (e) {
        log("resetStateOnVpnFailure: Error restarting scanner (unmounted): $e");
      }
    }
  }

  void _resetStateOnError() async {
    log("resetStateOnError: Resetting state due to unexpected error");
    if (mounted) {
      _showInvalidQrSnackBar();
      setState(() {
        _isLoading = false;
        scannedData = null;
        isScanned = false;
      });
      try {
        await _scannerController.start();
        log("resetStateOnError: Scanner restarted");
      } catch (e) {
        log("resetStateOnError: Error restarting scanner: $e");
      }
    } else {
      log("resetStateOnError: Widget not mounted, attempting to restart scanner");
      try {
        await _scannerController.start();
        log("resetStateOnError: Scanner restarted (unmounted)");
      } catch (e) {
        log("resetStateOnError: Error restarting scanner (unmounted): $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: onDetect,
          ),
          _buildScannerOverlay(),
          if (_isLoading)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 4,
                ),
              ),
            ),
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

  void showWarningDialog(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Error!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Invalid Qr Code.",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode ? Colors.white : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: screenWidth * 0.25,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isScanned = false;
                                });
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                "Okay",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isEarlyLeaveByTimeOnly(String currentIso, String endIso) {
    try {
      DateTime currentUtc =
          DateTime.parse(currentIso).toUtc().add(const Duration(hours: 6));
      DateTime endUtc =
          DateTime.parse(endIso).toUtc().add(const Duration(hours: 6));

      int currentInSeconds =
          currentUtc.hour * 3600 + currentUtc.minute * 60 + currentUtc.second;
      int endInSeconds =
          endUtc.hour * 3600 + endUtc.minute * 60 + endUtc.second;

      return currentInSeconds < endInSeconds;
    } catch (e) {
      log("Error comparing times: $e");
      return false;
    }
  }

  bool isTimeLate(String firstTimestamp, String secondTimestamp) {
    try {
      DateTime firstTimeUtc = DateTime.parse(firstTimestamp).toUtc();
      DateTime secondTimeUtc = DateTime.parse(secondTimestamp).toUtc();

      DateTime firstTimeBst = firstTimeUtc.add(const Duration(hours: 6));
      DateTime secondTimeBst = secondTimeUtc.add(const Duration(hours: 6));

      int firstTotalSeconds = firstTimeBst.hour * 3600 +
          firstTimeBst.minute * 60 +
          firstTimeBst.second;
      int secondTotalSeconds = secondTimeBst.hour * 3600 +
          secondTimeBst.minute * 60 +
          secondTimeBst.second;

      return firstTotalSeconds > secondTotalSeconds;
    } catch (e) {
      log('Error parsing timestamps: $e');
      return false;
    }
  }
}
