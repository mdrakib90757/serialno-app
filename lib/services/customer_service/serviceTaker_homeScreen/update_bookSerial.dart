import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/config/api.dart';
import 'package:http/http.dart' as http;

class UpdateBookSerialService {
  Future<bool> updateBookSerial({
    required String? id,
    required String? serviceCenterId,
    required String serviceTypeId,
    required bool forSelf,
    required String name,
    required String contactNo,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");
    print("UpdateBookSerial - ${token}");

    final url = Uri.parse(
      '${apiConfig.baseUrl}/service-centers/$serviceCenterId/services/$id',
    );
    debugPrint("📡 PUT BookSerial API: $url");

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "serviceTypeId": serviceTypeId,
          "forSelf": forSelf,
          "name": name,
          "contactNo": contactNo,
        }),
      );

      print(
        jsonEncode({
          "id": id,
          "serviceCenterId": serviceCenterId,
          "serviceTypeId": serviceTypeId,
          "forSelf": forSelf,
          "name": name,
          "contactNo": contactNo,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Update successful for ID: $id');
        print('✅ Update successful for ID: $serviceCenterId');
        debugPrint("✅ Edit updateBookSerial Success: ${response.body}");
        return true;
      } else {
        debugPrint("❌ edit updateBookSerial Failed: ${response.statusCode}");
        debugPrint("❗ Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print('Error during PUT updateBookSerial request: $e');
      return false;
    }
  }
}
