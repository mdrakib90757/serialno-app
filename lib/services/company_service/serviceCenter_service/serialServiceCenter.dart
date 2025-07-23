import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serial_no_app/utils/config/api_config.dart';

class SerialService {

  Future<bool> createNewSerial({
    required String serviceCenterId,
    required String serviceTypeId,
    required String serviceDate,
    required String name,
    required String contactNo,
    bool forSelf = false,
    required String serviceCenterName,

  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      debugPrint("❌ Token not found for creating serial.");
      return false;
    }


    final url = Uri.parse('${Api.baseUrl}/api/serial-no/service-centers/$serviceCenterId/services/book');



    final body = jsonEncode({
      "serviceTypeId": serviceTypeId,
      "serviceDate": serviceDate, // ISO 8601 format (e.g., "2025-07-21T17:40:14.462Z")
      "name": name,
      "contactNo": contactNo,
      "forSelf": forSelf
    });

    print("POST_serialService${
        jsonEncode({
          "serviceTypeId": serviceTypeId,
          "serviceDate": serviceDate, // ISO 8601 format (e.g., "2025-07-21T17:40:14.462Z")
          "name": name,
          "contactNo": contactNo,
          "forSelf": forSelf
        })
    }");

    debugPrint("📡 Creating new serial at: $url");
    debugPrint("📤 Body: $body");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint("✅ New serial created successfully: ${response.body}");
        return true;
      } else {
        debugPrint("❌ Failed to create serial. Status: ${response.statusCode}");
        debugPrint("❗ Body: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Exception during serial creation: $e");
      return false;
    }
  }
}