import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../conecttoschool/ConnectToSchoolScanQR.dart';
import '../models/vpn_config.dart';
import '../provider/learningmode_provider.dart';
import '../repositories/dashboard_repository.dart';
import '../services/vpn_engine.dart';
import '../settingsscreen/SettingsPage.dart';
import 'model/school_model.dart';
import 'model/student_with_schoolid.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  final DashboardRepository _dashboardRepository = DashboardRepository();
  bool _isLoading = false;
  bool _isSchoolLoading= false;
  String _schoolName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDashBoarsStudentInfo();
  }

  void _getDashBoarsStudentInfo()async{
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("Tocken ${token}");
    StudentDashboard? student = await _dashboardRepository.getDashboardSchoolInfo(token!);
    if (student != null) {
      print('User Profile: ${student.email}, ${student.type}');
      _getDashBoarsSchoolInfo();
      setState(() {
        _isLoading = false;
      });
    } else {
      print('Failed to fetch User profile info');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getDashBoarsSchoolInfo()async{
    setState(() {
      _isSchoolLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final schoolid = prefs.getString('dashboardSchoolId');
    print("Tocken ${schoolid}");
    SchoolModel? school = await _dashboardRepository.getDashboardSchoolInfobyId(schoolid!);
    if (school != null) {
      print('User School Profile: ${school.address}, ${school.schoolName}');
      downloadAndSaveFile(school.vpnUrl);
      setState(() {
        _schoolName = school.schoolName;
        _isSchoolLoading = false;
      });
    } else {
      print('Failed to fetch User School profile info');
      setState(() {
        _isSchoolLoading = false;
      });
    }
  }

  // Function to download file and save path
  // Future<String?> downloadAndSaveFile(String url) async {
  //   final Dio _dio = Dio();
  //   try {
  //     // Use a custom directory or temporary directory
  //     // For this example, we'll use a temporary directory in the app's cache
  //     final directory = await Directory.systemTemp.createTemp('downloads_');
  //
  //     // Create a file name
  //     String fileName = url.split('/').last;
  //     final filePath = '${directory.path}/$fileName';
  //
  //     // Download the file using Dio
  //     await _dio.download(
  //       url,
  //       filePath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           print('Progress: ${(received / total * 100).toStringAsFixed(0)}%');
  //         }
  //       },
  //     );
  //
  //     // Save path to SharedPreferences
  //     await _saveFilePath(filePath);
  //
  //     return filePath;
  //   } catch (e) {
  //     print('Error downloading file: $e');
  //     return null;
  //   }
  // }
  Future<String?> downloadAndSaveFile(String url) async {
    final Dio _dio = Dio();
    try {
      // Check if file path exists in SharedPreferences and if the file still exists
      final existingPath = await getFilePath();
      if (existingPath != null) {
        final existingFile = File(existingPath);
        if (await existingFile.exists()) {
          print('File already exists at: $existingPath');
          return existingPath; // Return existing path without downloading
        }
      }

      // If file doesn't exist, proceed with download
      final directory = await Directory.systemTemp.createTemp('downloads_');
      String fileName = url.split('/').last;
      final filePath = '${directory.path}/$fileName';

      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print('Progress: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      await _saveFilePath(filePath);
      return filePath;
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }
  // Save file path to SharedPreferences
  Future<void> _saveFilePath(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('downloaded_file_path', filePath);
  }

  // Retrieve file path from SharedPreferences
  Future<String?> getFilePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('downloaded_file_path');
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final learningModeProvider = Provider.of<LearningModeProvider>(context);
    // Format the time in HH:MM:SS format
    String formatTime(int seconds) {
      int hours = seconds ~/ 3600; // Calculate hours
      int minutes = (seconds % 3600) ~/ 60; // Calculate minutes
      int secs = seconds % 60; // Calculate seconds
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // App Bar with Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.settings, color: isDarkMode?Colors.white:Colors.black, size: 30),
                    onPressed: () {
                      //Go to settings page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Settingspage()),
                      );
                    },
                  ),

                  GestureDetector(
                    onTap: ()async{
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('dashboardSchoolId');
                      final userId = prefs.getString('dashboardUserId');
                      final userEmail = prefs.getString('dashboardEmail');
                      final path = await getFilePath();
                      print("School id: ${token}");
                      print("user id: ${userId}");
                      print("user email: ${userEmail}");
                      print("Ovpn path: ${path}");

                    },
                      child: Icon(Icons.emoji_events, color: Colors.amber, size: 30)),
                ],
              ),
              SizedBox(height: 20,),
              Column(
                children: [
                  Text(
                    "Welcome to",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "LEMO",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // School Status Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode?Colors.black87:Colors.purple.shade200,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.blueAccent.shade200)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circular Avatar (Left Side)
                    CircleAvatar(
                      radius: 25, // Adjust size as needed
                      backgroundColor: Colors.white, // Background color
                      backgroundImage: AssetImage("assets/images/school_logo.png"), // Replace with actual image
                    ),
                    SizedBox(width: 12), // Space between avatar and text

                    // Column with School Name and Status
                    _isSchoolLoading ? Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: isDarkMode ? Colors.black : Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ): Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // School Name Row with Icon
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.school, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Expanded(  // Ensures text takes up available space and wraps if needed
                                child: Text(
                                  _schoolName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,  // Allows text to wrap to multiple lines
                                  overflow: TextOverflow.visible, // Ensures visibility
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),

                          // School Status Text
                          Text(
                            "Status: School starts in 15 mins",
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                            softWrap: true,  // Allows multiline wrapping
                            overflow: TextOverflow.visible, // Prevents overflow cutting
                          ),
                        ],
                      ),
                    ),

                    // Expanded(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // School Name Row with Icon
                    //       Row(
                    //         children: [
                    //           Icon(Icons.school, color: Colors.white, size: 20),
                    //           SizedBox(width: 8),
                    //           _isSchoolLoading? SizedBox(
                    //             width: 24,
                    //             height: 24,
                    //             child: CircularProgressIndicator(
                    //               color: isDarkMode ? Colors.black : Colors.white,
                    //               strokeWidth: 2,
                    //             ),
                    //           ):Text(
                    //             _schoolName,
                    //             style: TextStyle(
                    //               fontSize: 16,
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       SizedBox(height: 5),
                    //
                    //       // School Status Text
                    //       Text(
                    //         "Status: School starts in 15 mins",
                    //         style: TextStyle(fontSize: 14, color: Colors.white70),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),

              SizedBox(height: 30),
              // Learn Mode Button
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ScanToConnectSchool()),
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none, // Ensure children can go outside
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode ? Colors.black87:Colors.grey.shade300,
                        border: Border.all(color: isDarkMode ?Colors.blueAccent.shade200:Colors.purpleAccent.shade200, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.security, size: 40, color: isDarkMode?Colors.white:Colors.black),
                          SizedBox(height: 5),
                          Text(
                            learningModeProvider.isLearningModeActive ? "Deactivate Learning Mode": "Activate Learn Mode",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -50,
                      bottom: -10,
                      child: Image.asset("assets/hand.png", width: 70), // Replace with actual image asset
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Status Text
              Text(
                learningModeProvider.isLearningModeActive ? "Status:Activated" : "Status: Not Activated",
                style: TextStyle(fontSize: 18, color: learningModeProvider.isLearningModeActive? Colors.green:Colors.red, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Timer Text
              Text(
                formatTime(learningModeProvider.elapsedSeconds),
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}