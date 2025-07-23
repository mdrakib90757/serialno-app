
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/serialService_model.dart';
import '../../../utils/config/api_config.dart';

class GetSerialsService {
  Future<List<SerialModel>> fetchSerialsByCenterAndDate(
      String serviceCenterId, String date) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      print("❌ Token not found in GetSerialsService");
      return [];

    }

    final url = Uri.parse('${Api.baseUrl}/api/serial-no/service-centers/$serviceCenterId/services?date=$date');

    // এই প্রিন্টটি নিশ্চিত করবে যে প্রতিবার সঠিক URL কল হচ্ছে
    print("✅✅✅ CALLING FINAL CORRECT URL: $url");

    print("📡 Fetching serials from: $url");


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
            .map((json) => SerialModel.fromJson(json as Map<String, dynamic>))
            .toList();

      } else {
        print("Error fetching serials: ${response.statusCode} - ${response.body}");
        print("Get_serial_service${response.body}");
        throw Exception('Failed to load serials');
      }
    } catch (e) {
      print("Exception during fetching serials: $e");
      throw Exception('Failed to load serials due to an exception');
    }
  }
}