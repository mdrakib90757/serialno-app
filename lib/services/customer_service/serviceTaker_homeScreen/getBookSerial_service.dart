import 'dart:convert';

import 'package:serialno_app/model/mybooked_model.dart';
import 'package:serialno_app/utils/config/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetBookSerial_service {
  Future<List<MybookedModel>> getbookSerialButtonService(String? date) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      print("❌ Token not found in get_statusUpDateButton");
      return [];
    }

    final url = Uri.parse("${apiConfig.baseUrl}/my-booked-services?date=$date");
    print("GetBookSerial_service - ${url}");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("----------- API Response Body GetBookSerial_service -----------");
      print(response.body);
      print("---------------------------------------");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => MybookedModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print(
          "Error fetching book_serials: ${response.statusCode} - ${response.body}",
        );
        print("Get_book_serial_service${response.body}");
        throw Exception('Failed to load book_serials');
      }
    } catch (e) {
      print("Exception during fetching serials:- $e");
      throw Exception('Failed to load book_serials due to an exception-${e}');
    }
  }
}
