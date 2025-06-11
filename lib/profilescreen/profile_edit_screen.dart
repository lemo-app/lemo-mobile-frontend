import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lemoios/profilescreen/ProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/dashboard_repository.dart';
import 'model/Student.dart';

class EditProfileScreen extends StatefulWidget {
  final Student? student;

  const EditProfileScreen({
    Key? key,
   required this.student
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final DashboardRepository _dashboardRepository = DashboardRepository();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _genderController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student!.fullname);
    _emailController = TextEditingController(text: widget.student!.email);
    _ageController = TextEditingController(text: widget.student!.age.toString());
    _genderController = TextEditingController(text: widget.student!.gender);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Bar with Back Button and Title
              Row(
                children: [
                  _circularButton(Icons.chevron_left, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Profilescreen()),
                    );
                  },isDarkMode),
                  const SizedBox(width: 16),
                  const Text(
                    'Edit Profile Info',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              /// Text Fields
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _genderController,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),

              /// Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async{
                    // Add update logic here
                    print('Updated Name: ${_nameController.text}');
                    print('Updated Email: ${_emailController.text}');
                    print('Updated Phone: ${_ageController.text}');
                    setState(() {
                      _isLoading = true;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    String? userId = await prefs.getString('dashboardUserId');
                    await _dashboardRepository.updateProfile(_nameController.text, int.parse(_ageController.text),_genderController.text,userId!);
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Profilescreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.white : Colors.blueAccent.shade100,
                    foregroundColor: isDarkMode ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading ? Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: isDarkMode ? Colors.white : Colors.black,
                        strokeWidth: 2,
                      ),
                    ),
                  ): Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Circular Button Widget
  Widget _circularButton(IconData icon, VoidCallback onPressed,bool isDarkMode) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDarkMode?Colors.black87:Colors.purple.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
