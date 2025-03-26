import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../conecttoschool/ConnectToSchoolScanQR.dart';
import '../provider/LearningModeProvider.dart';
import '../settingsscreen/SettingsPage.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {


  @override
  Widget build(BuildContext context) {
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
                    icon: Icon(Icons.settings, color: Colors.purple, size: 30),
                    onPressed: () {
                      //Go to settings page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Settingspage()),
                      );
                    },
                  ),

                  Icon(Icons.emoji_events, color: Colors.amber, size: 30),
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
                  color: Colors.purple.shade200,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circular Avatar (Left Side)
                    CircleAvatar(
                      radius: 25, // Adjust size as needed
                      backgroundColor: Colors.white, // Background color
                      backgroundImage: AssetImage("assets/school_logo.png"), // Replace with actual image
                    ),
                    SizedBox(width: 12), // Space between avatar and text

                    // Column with School Name and Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // School Name Row with Icon
                          Row(
                            children: [
                              Icon(Icons.school, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "ST. Thomas' Moorside",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),

                          // School Status Text
                          Text(
                            "Status: School starts in 15 mins",
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   padding: EdgeInsets.all(20),
              //   decoration: BoxDecoration(
              //     color: Colors.purple.shade200,
              //     borderRadius: BorderRadius.circular(40),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Icon(Icons.school, color: Colors.white, size: 20),
              //           SizedBox(width: 8),
              //           Text(
              //             "ST. Thomas' Moorside",
              //             style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 5),
              //       Text(
              //         "Status: School starts in 15 mins",
              //         style: TextStyle(fontSize: 14, color: Colors.white70),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 30),
              // Learn Mode Button
              Stack(
                clipBehavior: Clip.none, // Ensure children can go outside
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ScanToConnectSchool()),
                      );
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                        border: Border.all(color: Colors.purpleAccent.shade200, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.security, size: 40, color: Colors.black),
                          SizedBox(height: 5),
                          Text(
                            learningModeProvider.isLearningModeActive ? "Deactivate Learning Mode": "Activate Learn Mode",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -50,
                    bottom: -10,
                    child: Image.asset("assets/hand.png", width: 70), // Replace with actual image asset
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Status Text
              Text(
                "Status: Not Activated",
                style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
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