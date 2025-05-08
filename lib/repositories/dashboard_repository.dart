import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/model/school_model.dart';
import '../dashboard/model/student_with_schoolid.dart';
import '../services/data_provider.dart';
import '../utils/api.dart';


class DashboardRepository{
  // Private instance of DataProvider for making HTTP requests
  final DataProvider _dataProvider = DataProvider();
  //static final String ip = "http://127.0.0.1:3001/";
  //   //static final String ip = "http://192.168.0.100:3001/";
  //   //static final String ip = "http://192.168.68.118:3001/";


  Future<StudentDashboard?> getDashboardSchoolInfo(String token) async {
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
        StudentDashboard student = StudentDashboard.fromJson(response.data);
        // Get instance of SharedPreferences for local storage
        final prefs = await SharedPreferences.getInstance();
        // Extract authentication data from response
        final schoolId = response.data['school']['_id'];
        final userId = response.data['_id'];
        final email = response.data['email'];
        // Store authentication data in local storage
        await prefs.setString('dashboardSchoolId', schoolId);
        await prefs.setString('dashboardUserId', userId);
        await prefs.setString('dashboardEmail', email);

        // You can also store the student data or use it for further processing
        return student; // ✅ Return the student object
      }

      return null; // ❌ Return null if the request failed or no valid data

    } catch (e) {
      print("Error fetching profile info: $e");
      return null; // ❌ Return null if an error occurs
    }
  }


  Future<SchoolModel?> getDashboardSchoolInfobyId(String schoolId) async {
    try {
      // Make GET request to fetch user profile
      final response = await _dataProvider.fetchData(
        'GET',
        '${Api.baseUrl}schools/${schoolId}',
        header: {'Content-Type': 'application/json'},
      );

      print("Token: $schoolId");
      print("Response: ${response?.data}");
      print("Status: ${response?.statusCode}");

      // Check if request was successful (HTTP 200 OK)
      if (response != null && response.statusCode == 200) {
        // Parse the response data into a Student model
        SchoolModel student = SchoolModel.fromJson(response.data);
        // You can also store the student data or use it for further processing
        return student; // ✅ Return the student object
      }

      return null; // ❌ Return null if the request failed or no valid data

    } catch (e) {
      print("Error fetching profile info: $e");
      return null; // ❌ Return null if an error occurs
    }
  }


}