import 'package:shared_preferences/shared_preferences.dart';

import '../profilescreen/model/Student.dart';
import '../services/data_provider.dart';
import '../utils/api.dart';


// AuthRepository class to handle authentication-related operations
class AuthRepository {
  // Private instance of DataProvider for making HTTP requests
  final DataProvider _dataProvider = DataProvider();
  //static final String ip = "http://127.0.0.1:3001/";
  //static final String ip = "http://192.168.0.100:3001/";
  //static final String ip = "http://192.168.68.118:3001/";

  // Sign-in method that takes email and password as parameters
  // Returns Future<bool> indicating success/failure
  Future<String> signIn(String emailId, String password) async {
    // Make POST request to login endpoint using DataProvider
    final response = await _dataProvider.fetchData(
      'POST',
      '${Api.baseUrl}auth/login',
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
    return response!.data['message'];
  }

  // Sign-up method that takes email and user type as parameters
  // Returns Future<bool> indicating success/failure
  Future<String> signUp(String emailId, String userType) async {
    // Make POST request to signup endpoint using DataProvider
    final response = await _dataProvider.fetchData(
      'POST',
      '${Api.baseUrl}auth/signup',
      data: {
        'email': emailId,
        'type': userType,
      },
      header: {'Content-Type': 'application/json'},
    );

    print("Data: ${emailId} ${userType}");
    print("Response: ${response!.statusCode}");
    print("Response data: ${response!.data}");
    // Check if signup was successful based on response status
    if (response!.statusCode == 201){
      await sendEmail(emailId,response!.data["message"],response!.data["verificationEmail"]);
      final prefs = await SharedPreferences.getInstance();
      final email = response.data['email'];
      await prefs.setString('registrationEmail', email);
      return response!.data["status"];
    }
    return response!.data;
  }

  Future<bool> sendEmail(String emailId, String subject, String body) async {
    // Make POST request to send email endpoint using DataProvider
    final response = await _dataProvider.fetchData(
      'POST',
      '${Api.baseUrl}email/send',
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

  Future<bool> veryFyEmail(String emailId, String tempPassword, String newPassword, String confirmPassword) async {
    final response = await _dataProvider.fetchData(
      'POST',
      '${Api.baseUrl}verify-email',
      data: {
        'email': emailId,
        'temp_password': tempPassword,
        'new_password' : newPassword,
        'new_password_confirm' : confirmPassword,
      },
      header: {'Content-Type': 'application/json'},
    );

    print("Data: ${emailId} ${tempPassword} ${newPassword} ${confirmPassword}");
    print("Response: ${response!.data}");
    print("StatusCode: ${response!.statusCode}");
    // Check if signup was successful based on response status
    if (response!.statusCode == 200){
      final res = await signIn(emailId,newPassword);
      if(res == "true"){
        return true;
      }else{
        return false;
      }
    }
    return false;
  }

  Future<Student?> getProfileInfo(String token) async {
    try {
      // Make GET request to fetch user profile
      final response = await _dataProvider.fetchData(
        'GET',
        '${Api.baseUrl}users/me',
        header: { "Authorization": "Bearer $token" },
      );

      print("Token: $token");
      print("Response: ${response?.data}");
      print("Status: ${response?.statusCode}");

      // Check if request was successful (HTTP 200 OK)
      if (response != null && response.statusCode == 200) {
        // Parse the response data into a Student model
        Student student = Student.fromJson(response.data);

        // You can also store the student data or use it for further processing
        return student; // ✅ Return the student object
      }

      return null; // ❌ Return null if the request failed or no valid data

    } catch (e) {
      print("Error fetching profile info: $e");
      return null; // ❌ Return null if an error occurs
    }
  }


  Future<bool> conectToSchool(String emailId, String schoolId) async {
    // Make POST request to signup endpoint using DataProvider
    final response = await _dataProvider.fetchData(
      'POST',
      '${Api.baseUrl}schools/connect',
      data: {
        'user_email': emailId,
        'school_id': schoolId,
      },
      header: {'Content-Type': 'application/json'},
    );

    print("Data: ${emailId} ${schoolId}");
    print("Response: ${response!.data}");
    // Check if signup was successful based on response status
    if (response!.data["status"] == "success") {
      return true;
    }
    return false;
  }


  Future<bool> forgetPassword(String emailId) async {
    // Make POST request to signup endpoint using DataProvider
    final response = await _dataProvider.fetchData(
      'POST',
      '${Api.baseUrl}users/forgot-password-request',
      data: {
        'email': emailId,
      },
      header: {'Content-Type': 'application/json'},
    );

    print("Data: ${emailId}");
    print("Response: ${response!.statusCode}");
    print("Response data: ${response!.data}");
    // Check if signup was successful based on response status
    if (response!.statusCode == 200){
      return true;
    }
    return false;
  }


  Future<String> deleteAccount(String userID) async {
    // Make POST request to login endpoint using DataProvider
    final response = await _dataProvider.fetchData(
      'DELETE',
      '${Api.baseUrl}users/${userID}',
      header: {'Content-Type': 'application/json'},
    );

    print("Data: ${userID}");
    print("Response: ${response!.data}");
    print("Status: ${response!.statusCode}");

    // Check if request was successful (HTTP 200 OK)
    if (response!.statusCode == 200) {
      return "true";
    }
    return response!.data['message'];
  }


}
