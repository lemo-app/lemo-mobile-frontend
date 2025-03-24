
import 'package:shared_preferences/shared_preferences.dart';

import '../services/dataProvider.dart';

// AuthRepository class to handle authentication-related operations
class AuthRepository {
  // Private instance of DataProvider for making HTTP requests
  final DataProvider _dataProvider = DataProvider();

  // Sign-in method that takes email and password as parameters
  // Returns Future<bool> indicating success/failure
  Future<String> signIn(String emailId, String password) async {
    // Make POST request to login endpoint using DataProvider
    final response = await _dataProvider.fetchData(
      'POST',
      'http://127.0.0.1:3001/auth/login',
      data: {
        'email': emailId,
        'password': password,
      },
      header: {'Content-Type': 'application/json'},
    );

    print("Data: ${emailId} ${password}");
    print("Response: ${response!.data}");
    print("Status: ${response!.statusCode}");

    // Check if request was successful (HTTP 200 OK)
    if (response!.statusCode == 200) {
      // Get instance of SharedPreferences for local storage
      final prefs = await SharedPreferences.getInstance();
      // Extract authentication data from response
      final token = response.data['token'];
      final userId = response.data['userId'];
      final email = response.data['email'];
      // Store authentication data in local storage
      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      await prefs.setString('email', email);

     return "true";
    }
    return response!.data;
  }

  // Sign-up method that takes email and user type as parameters
  // Returns Future<bool> indicating success/failure
  Future<bool> signUp(String emailId, String userType) async {
    // Make POST request to signup endpoint using DataProvider
    final response = await _dataProvider.fetchData(
      'POST',
      'http://127.0.0.1:3001/auth/signup',
      data: {
        'email': emailId,
        'type': userType,
      },
      header: {'Content-Type': 'application/json'},
    );

    print("Data: ${emailId} ${userType}");
    print("Response: ${response!.data}");
    // Check if signup was successful based on response status
    if (response!.data["status"] == "success"){
      await sendEmail(emailId,response!.data["message"],response!.data["verificationEmail"]);
      return true;
    }
    return false;
  }

  Future<bool> sendEmail(String emailId, String subject, String body) async {
    // Make POST request to signup endpoint using DataProvider
    final response = await _dataProvider.fetchData(
      'POST',
      'http://127.0.0.1:3001/email/send',
      data: {
        'to': emailId,
        'subject': subject,
        'body': body,
      },
      header: {'Content-Type': 'application/json'},
    );

    print("Data: ${emailId} ${subject} ${body}");
    print("Response: ${response!.data}");
    // Check if signup was successful based on response status
    if (response!.data["status"] == "success") {
      // final prefs = await SharedPreferences.getInstance();
      // final token = response.data['token'];
      // final userId = response.data['userId'];
      // final email = response.data['email'];
      //
      // await prefs.setString('token', token);
      // await prefs.setString('userId', userId);
      // await prefs.setString('email', email);

      return true;
    }
    return false;
  }
}