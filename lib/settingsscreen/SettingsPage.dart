import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/login_screen.dart';
import '../dashboard/DashboardScreen.dart';
import '../profilescreen/ProfileScreen.dart';
import '../repositories/auth_repository.dart';
import '../utils/AlertDiaglogs.dart';


class Settingspage extends StatefulWidget {
  const Settingspage({super.key});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  // Authentication Repository for login
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Dashboardscreen()),
                    );
                  }),
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _circularButton(Icons.logout_outlined, () {
                    // Settings Action
                    _logOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false, // this removes all previous routes
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
                  showWarningDialog(context);
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
              // color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row with Icon on Left & Text on Right
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Warning Icon (Left Side)
                    Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 10),

                    // Warning Title & Message (Right Side)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Warning!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white:Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Are you sure you want to delete your account completely.",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white:Colors.black54),
                          ),
                          const SizedBox(height: 10),

                          // "Okay" Button
                          Row(
                            children: [
                              SizedBox(
                                width: screenWidth * 0.25,
                                child: ElevatedButton(
                                  onPressed: () async{
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    final prefs = await SharedPreferences.getInstance();
                                    final userID = prefs.getString('userId');
                                    var res = await _authRepository.deleteAccount(userID!);
                                    if(res == "true"){
                                      _logOut();
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoginScreen()),
                                            (Route<dynamic> route) => false, // this removes all previous routes
                                      );
                                    }else{
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      DiaglogUtils.showDeleteWarningDialog(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: _isLoading? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: isDarkMode ? Colors.black : Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ):Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              SizedBox(
                                width: screenWidth * 0.25,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close Dialog
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: const Text(
                                    "No",
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Profilescreen()),
              );
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