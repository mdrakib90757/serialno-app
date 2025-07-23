

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileProvider with ChangeNotifier{


  String? _token;
  String? get token=>_token;

  bool _isLoading=false;
  bool get isLoading=>_isLoading;


Future<bool>updateProfile({
  required String name,
  required String? loginName,
  required String mobileNo,
  required String email,
  required String gender,
  String? dateOfBirth, // ISO format or null
})async{
  _isLoading = true;
  notifyListeners();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');

  print("token${token}");

  final url = Uri.parse('https://serialno-api.somee.com/api/me/profile');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}"
      },
      body: jsonEncode({
        "name": name,
        "loginName":loginName,
        "mobileNo": mobileNo,
        "email": email,
        "gender": gender,
        "dateOfBirth": dateOfBirth, // null দিলে null পাঠাবে
      }),
    );
print(jsonEncode({""
    "name": name,
  "loginName":loginName,
  "mobileNo": mobileNo,
  "email": email,
  "gender": gender,
  "dateOfBirth": dateOfBirth, }));

    _isLoading = false;
    notifyListeners();

    print(response.body);
    print("token${_token}");
    print("token1${token}");

    if (response.statusCode == 200 || response.statusCode == 201) {

      debugPrint("✅ Profile POST Success: ${response.body}");

      return true;
    } else {
      debugPrint("❌ Profile POST Failed: ${response.statusCode}");
      debugPrint("❗ Body: ${response.body}");
      return false;
    }
  } catch (e) {
    _isLoading = false;
    notifyListeners();
    debugPrint("❌ Error: $e");
    return false;
  }


}


}


