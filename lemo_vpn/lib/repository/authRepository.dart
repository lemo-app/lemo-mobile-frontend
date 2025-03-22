
import 'package:shared_preferences/shared_preferences.dart';

import '../services/dataProvider.dart';

class AuthRepository {
  final DataProvider _dataProvider = DataProvider();

  Future<bool> signIn(String emailId, String password) async {
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

    if (response!.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final token = response.data['token'];
      final userId = response.data['userId'];
      final email = response.data['email'];

      await prefs.setString('token', token);
      await prefs.setString('userId', userId);
      await prefs.setString('email', email);

     return true;
    }
    return false;
  }

  Future<bool> signUp(String emailId, String userType) async {
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