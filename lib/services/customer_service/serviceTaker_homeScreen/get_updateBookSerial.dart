import 'dart:convert';

import 'package:serialno_app/model/mybooked_model.dart';
import 'package:serialno_app/utils/config/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Get_UpdateBookSerial_service {
  Future<List<MybookedModel>> get_UpdatebookSerial_Service(String? date) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      print("❌ Token not found in get_Update_bookSerial_Service");
      return [];
    }

    final url = Uri.parse("${apiConfig.baseUrl}/my-booked-services?date=$date");
    print("getUpdate_bookSerial_Service - ${url}");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => MybookedModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print(
          "Error fetching getUpdate_bookSerial_Service: ${response.statusCode} - ${response.body}",
        );
        print("get_Update_bookSerial_Service${response.body}");
        throw Exception('Failed to load get_Update_bookSerial_Service');
      }
    } catch (e) {
      print("Exception during fetching serials:-- $e");
      throw Exception('Failed to load book_serials due to an exception');
    }
  }
}
