import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/config/api.dart';
import 'package:http/http.dart' as http;

class CommentCancelButtonService {
  Future<bool> putCancelButton({
    required String? id,
    required String? serviceCenterId,
    required String serviceTypeId,
    required String comment,
    required String status,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");
    print("CommentCancelButton - ${token}");

    final url = Uri.parse(
      '${apiConfig.baseUrl}/service-centers/$serviceCenterId/services/$id',
    );
    debugPrint("📡 PUT CommentCancelButton API: $url");
    print("PUT CommentCancelButton API: - ${url}");

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },

        body: jsonEncode({
          "serviceTypeId": serviceTypeId,
          "comment": comment,
          "status": status,
        }),
      );

      print(
        jsonEncode({
          "id": id,
          "serviceCenterId": serviceCenterId,
          "serviceTypeId": serviceTypeId,
          "comment": comment,
          "status": status,
        }),
      );

      print("----------- API Response Body  CommentCancelButton -----------");
      print(response.body);
      print("---------------------------------------");

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ CommentCancelButton for ID: $id');
        print('✅ CommentCancelButton for ID: $serviceCenterId');
        debugPrint("✅ CommentCancelButton Success: ${response.body}");
        return true;
      } else {
        debugPrint("❌ CommentCancelButton Failed: ${response.statusCode}");
        debugPrint("❗ Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print('Error during PUT CommentCancelButton request: $e');
      return false;
    }
  }
}
