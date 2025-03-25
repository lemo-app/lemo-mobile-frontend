import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/authRepository.dart';
import '../settingsscreen/SettingsPage.dart';
import 'model/Student.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;
  String _name = "";
  String _email = "";

  @override
  void initState() {
    // TODO: implement initState
    _getProfileInfo();
    super.initState();
  }

  void _getProfileInfo()async{
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("Tocken ${token}");
    Student? student = await _authRepository.getProfileInfo(token!);
    if (student != null) {
      print('User Profile: ${student.email}, ${student.type}');
      _name = student.email;
      _email = student.email;
      setState(() {
        _isLoading = false;
      });
    } else {
      print('Failed to fetch profile info');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      //backgroundColor: Colors.purple.shade50,
      body: SafeArea(
        child: _isLoading ? Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: isDarkMode ? Colors.black : Colors.white,
              strokeWidth: 2,
            ),
          ),
        ): Padding(
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
              GestureDetector(
                onTap: ()async{

                },
                child: Center(
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
                        _name,
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
              ),
              SizedBox(height: 30),

              // Input Fields
              _inputField(Icons.person, "Full Name", _name),
              SizedBox(height: 10),
              _inputField(Icons.phone, "Phone Number", "+8801712653389"),
              SizedBox(height: 10),
              _inputField(Icons.email, "Email Address", _email),
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