import 'package:flutter/material.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const Settingspage()),
                      // );
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
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.purple.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.school, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "ST. Thomas' Moorside",
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Status: School starts in 15 mins",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Learn Mode Button
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                      border: Border.all(color: Colors.black12, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.security, size: 40, color: Colors.black),
                        SizedBox(height: 5),
                        Text(
                          "Activate Learn Mode",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Image.asset("assets/hand.png", width: 50), // Replace with actual image asset
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
                "00:00:00",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}