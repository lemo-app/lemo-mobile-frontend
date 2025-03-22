import 'package:flutter/material.dart';
import 'package:lemo_vpn/authentication/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Settingspage extends StatefulWidget {
  const Settingspage({super.key});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {

  Future<void> _logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all stored data
    print("All preferences cleared!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circularButton(Icons.chevron_left, () {
                    Navigator.pop(context);
                  }),
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _circularButton(Icons.logout_outlined, () {
                    // Settings Action
                    _logOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }),
                ],
              ),
              SizedBox(height: 30),

              // General Section
              _sectionTitle("General"),
              _settingsItem("My Profile"),
              _settingsItem("Contact Us"),
              SizedBox(height: 20),

              // Security Section
              _sectionTitle("Security"),
              _settingsItem("Change Password"),
              _settingsItem("Privacy Policy", subtitle: "Choose what data you share with us"),
              SizedBox(height: 20),

              // Delete Account Button
              GestureDetector(
                onTap: () {
                  // Delete Account Action
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        "Delete Account",
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.chevron_right, color: Colors.pink),
                    ],
                  ),
                ),
              ),
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

  // Section Title Widget
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
      ),
    );
  }

  // Settings Item Widget
  Widget _settingsItem(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            // Navigate to respective screen
            if(title == "My Profile"){
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Profilescreen()),
              // );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Icon(Icons.chevron_right, color: Colors.black54),
              ],
            ),
          ),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              subtitle,
              style: TextStyle(fontSize: 13, color: Colors.black45),
            ),
          ),
        Divider(height: 1, color: Colors.grey.shade300),
      ],
    );
  }
}