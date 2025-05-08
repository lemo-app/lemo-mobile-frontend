import 'package:flutter/material.dart';

class StudentInfoScreen extends StatelessWidget {
  const StudentInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align all text to left
            children: [
              // Large Text: Connect to School
              SizedBox(height: 50,),
              const Text(
                'Connect to School',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent
                ),
              ),
              const SizedBox(height: 10),
              // Small Text: Step 2
              Text(
                'Step 2: Your Information',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 30),
              // Row: Avatar + School Name
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Left-align the row
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    child: const Icon(
                      Icons.school,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "St. Thomas' Moorside",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Section: Your Name
              Text(
                'Your Name',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'John Doe', // Replace with actual name
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                thickness: 1,
              ),
              const SizedBox(height: 10),
              // Section: Your Roll/Role
              Text(
                'Your Roll/Role',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '43', // Roll number
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                thickness: 1,
              ),
              const SizedBox(height: 10),
              // Section: Home Room Teacher
              Text(
                'Home Room Teacher',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Ms. Jane Smith', // Replace with actual teacher name
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                thickness: 1,
              ),
              const Spacer(), // Pushes button to bottom
              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NextScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.white : Colors.blueAccent,
                    foregroundColor: isDarkMode ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Circular border
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Next Step')),
      body: const Center(child: Text('Step 3: Do Something Else!')),
    );
  }
}