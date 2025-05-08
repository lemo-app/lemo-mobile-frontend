
import 'package:shared_preferences/shared_preferences.dart';

import '../services/data_provider.dart';
import '../utils/api.dart';

class QrRepository{
  // Private instance of DataProvider for making HTTP requests
  final DataProvider _dataProvider = DataProvider();
  //static final String ip = "http://127.0.0.1:3001/";
  //static final String ip = "http://192.168.0.100:3001/";
  //static final String ip = "http://192.168.68.118:3001/";

  // Sign-in method that takes email and password as parameters
  // Returns Future<bool> indicating success/failure
  Future<String> createSession(String token,String studentId, String schoolId,String startTime,String endTime,String status,bool tardy,bool earlyLeave) async {
    // Make POST request to login endpoint using DataProvider
    final response = await _dataProvider.fetchData(
      'POST',
      '${Api.baseUrl}sessions/create',
      data: {
        'student': studentId,
        'school': schoolId,
        'start_time': startTime,
        'end_time': endTime,
        'status': status,
        'tardy': tardy,
        'early_leave': earlyLeave,
      },
      header: { "Authorization": "Bearer $token" },
    );

    print("Data: ${studentId} ${schoolId} ${startTime} ${endTime} ${status} ${tardy} ${earlyLeave}");
    print("Response: ${response!.data}");
    print("Status: ${response!.statusCode}");
    print("SessionId: ${response!.data['session']['_id']}");

    // Check if request was successful (HTTP 200 OK)
    if (response!.data['status']=="success") {
      final prefs = await SharedPreferences.getInstance();
      var sessionID = response!.data['session']['_id'];
      prefs.setString('sessionId', sessionID);
      return response!.data['message'];
    }
    return response!.data['message'];
  }

  Future<String> endingSession(
      String token, String endtime, String status, bool earlyLeave,String sessionId) async {
    try {
      final response = await _dataProvider.fetchData(
        'PATCH',
        '${Api.baseUrl}sessions/$sessionId',
        data: {
          'end_time': endtime,
          'status': status,
          'early_leave':earlyLeave
        },
        header: {
          "Authorization": "Bearer $token"
        },
      );

      print("Data Sent: Status: $status | EndTime: $endtime | Token: $token | SessionID: $sessionId");
      print("Response: ${response?.data}");
      print("Status: ${response?.statusCode}");

      // Corrected Status Check for PATCH response
      if (response?.statusCode == 200 || response?.statusCode == 204) {
        if (response!.data['status'] == "success") {
          return response.data['message'];
        }
      }

      return "Failed to retrieve";
    } catch (e) {
      print("Error ending session: $e");
      return "Error ending session";
    }
  }


// Future<String> endingSession(String token,String endtime,String status,String sessionId) async {
  //   // Make POST request to login endpoint using DataProvider
  //   final response = await _dataProvider.fetchData(
  //     'PATCH',
  //     '${ip}sessions/${sessionId}',
  //     data: {
  //       'end_time': endtime,
  //       'status': status,
  //     },
  //     header: { "Authorization": "Bearer $token" },
  //   );
  //
  //   print("Data: ${status} ${endtime} ${token} ${sessionId}");
  //   print("Response: ${response!.data}");
  //   print("Status: ${response!.statusCode}");
  //
  //   // Check if request was successful (HTTP 200 OK)
  //   if (response!.statusCode == 200 && response!.data['status']=="success") {
  //     return response!.data['message'];
  //   }
  //   return "Failed to retrive";
  // }


}