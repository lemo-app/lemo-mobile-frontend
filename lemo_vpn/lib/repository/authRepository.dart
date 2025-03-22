
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
      // final prefs = await SharedPreferences.getInstance();
      // final user = response.data['response']['user'];
      // final token = response.data['response']['token'];
      // final userId = response.data['response']['user_id'];
      // final expires = response.data['response']['expires'];
      // final email = user['authentication']['email']['email'];
      //
      // await prefs.setString('token', token);
      // await prefs.setString('user_id', userId);
      // await prefs.setInt('expires', expires);
      // await prefs.setString('email', email);

     return true;
    }
    return false;
  }
}