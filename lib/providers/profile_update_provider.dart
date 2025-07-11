

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileProvider with ChangeNotifier{

  bool _isLoading=false;
  bool get isLoading=>_isLoading;
  

Future<bool>updateProfile({
  required String name,
  required String loginName,
  required String mobileNo,
  required String email,
  required String gender,
  String? dateOfBirth, // ISO format or null
})async{
  _isLoading = true;
  notifyListeners();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token'); // তোমার login এর পর save করা টোকেন

  final url = Uri.parse('https://serialno-api.somee.com/api/me/profile');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJlOTRkZDQxZS1jNGU1LTRjNWUtOTFiYS03NjMwZjBmNDZkYzAiLCJuYW1lIjoidXNlci1iYXBweWIiLCJ1c2VyVHlwZSI6IkNvbXBhbnkiLCJsb2dpbk5hbWUiOiJVc2VyLVJha2liICIsImVtYWlsIjoidXNlci1iYXBweWJAZ21haWwuY29tIiwibW9iaWxlTm8iOiIwMTYwMTcxMTI2MCIsImV4cCI6MTc1MjI0MDI5NywiaXNzIjoiaHR0cDovL2hybnNvZnQuY29tIiwiYXVkIjoiaHR0cDovL2hybnNvZnQuY29tIn0._Rh9cKrysyiPg5x2HchQIEAPcB2rvwW5JzRiygTiXxs',
      },
      body: jsonEncode({
        "name": name,
        "loginName": loginName,
        "mobileNo": mobileNo,
        "email": email,
        "gender": gender,
        "dateOfBirth": dateOfBirth, // null দিলে null পাঠাবে
      }),
    );

    _isLoading = false;
    notifyListeners();

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


