
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class AuthService {
  String ApiUrl = "https://serialno-api.somee.com/api/serial-no/register-service-center";
  Future<Map<String, dynamic>?> registerServiceCenter({
    required String name,
    required String addressLine1,
    required String addressLine2,
    required String contactName,
    required String email,
    required String phone,
    required String organizationName,
    required int businessTypeId,
    required String loginName,
    required String password,
  }) async {
    try {
      final url = Uri.parse(ApiUrl);
      final response = await http.post(
          url,
          headers: {
            "content-type": "application/json"
          },
          body: jsonEncode({
            "name": name,
            "addressLine1": addressLine1,
            "addressLine2": addressLine2,
            "contactName": contactName,
            "email": email,
            "phone": phone,
            "organizationName": organizationName,
            "businessTypeId": businessTypeId,
            "loginName": loginName,
            "password": password,
          }));
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': User_Model.fromJson(data)};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          "message": errorData["errorMessage"] ?? 'Registration failed'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Server error: ${e.toString()}'
      };
    }
  }

  //LoginMethod
  Future<Map<String, dynamic>> login(
      {required String loginName, required String password }) async {
    final String APIURl = "https://serialno-api.somee.com/api/auth/login";

    final url = Uri.parse(APIURl);
    final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'},
        body: jsonEncode({
          "loginName": loginName,
          "password": password
        })
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
     throw Exception (errorData["errorMessage"] ?? "Login failed");
    }
  }



  Future<Map<String, dynamic>> getProfile(String token) async {
    final uri = Uri.parse("https://serialno-api.somee.com/api/me/profile"); // আপনার প্রোফাইল এপিআই
    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load profile. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }




//ServiceTaker Method
  Future<Map<String, dynamic>?> ServiceTakerRegister({
    String? id,
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String loginName,
    required String password,

  }) async {
    final String APIURl = "https://serialno-api.somee.com/api/serial-no/register-service-taker";
    final payload = {
      "name": name,
      "email": email,
      "phone": phone, // Note: lowercase 'phone' as per working example
      "gender": gender,
      "loginName": loginName,
      "password": password,
    };

    try {
      final response = await http.post(Uri.parse(APIURl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload)
      );
      debugPrint("API Response: ${response.statusCode} - ${response.body}");
      print(response.body);
      print("API Response: ${response.statusCode} - ${response
          .body}"); // Debug print
      print("Request Body: ${jsonEncode({
        "Phone": phone,
        // ... other fields
      })}");
      print(response.statusCode);


      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'data': responseData};
      } else {
        final errorMessage = responseData['errorMessage'] ?? 'Registration failed';
        return{
          'success': false,
          'message': errorMessage,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
    };
  }
}
}


//BusinessType
class BusinessTypeService {
   final String url = "https://serialno-api.somee.com/api/business-types";

   Future<List<Businesstype>> getBusinessTypes() async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
   print('Trying to fetch from:$url');
      print('API Response Status: ${response.statusCode}'); // Debug log
      print('API Response Body: ${response.body}'); //
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isEmpty) {
          throw Exception('API returned empty business types list');
        }
        return data.map((json) => Businesstype.fromJson(json)).toList();
      }

      throw Exception('Failed with status ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load business types: ${e.toString()}');
    }
  }
}





