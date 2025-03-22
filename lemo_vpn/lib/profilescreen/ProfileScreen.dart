import 'package:flutter/material.dart';

import '../settingsscreen/SettingsPage.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.purple.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circularButton(Icons.chevron_left, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Settingspage()),
                    );
                  }),
                  Text(
                    "Profile",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _circularButton(Icons.edit, () {
                    // Settings Action
                  }),
                ],
              ),
              SizedBox(height: 30),

              // Profile Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/men/75.jpg", // Replace with actual image
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tanya Myroniuk",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      margin: EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text(
                            "ST. Thomas’ Moorside",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Input Fields
              _inputField(Icons.person, "Full Name", "Tanya Myroniuk"),
              SizedBox(height: 10),
              _inputField(Icons.phone, "Phone Number", "+8801712653389"),
              SizedBox(height: 10),
              _inputField(Icons.email, "Email Address", "tanya.myroniuk@gmail.com"),
            ],
          ),
        ),
      ),
    );
  }

  // Circular Button Widget
  Widget _circularButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.purple.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  // Input Field Widget
  Widget _inputField(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.black54),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.purple),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
          controller: TextEditingController(text: value),
        ),
      ],
    );
  }
}