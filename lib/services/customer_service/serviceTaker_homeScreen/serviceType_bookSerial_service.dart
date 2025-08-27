import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../model/service_type_model.dart';
import '../../../utils/config/api.dart';

class serviceTypeserialbook_service {
  Future<List<serviceTypeModel>> fetchServiceType_serialbook(
    String companyId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");
    if (token == null) {
      print("❌ Token not found in SharedPreferences for GET request.");
      return [];
    }

    final String urlString =
        '${apiConfig.baseUrl}/companies/$companyId/service-types';
    final url = Uri.parse(urlString);

    //final url = Uri.parse('${apiConfig.baseUrl}/service-centers/$companyId/service-types');
    try {
      final response = await http.get(
        url,
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📡ServiceType serialBook - : ${url}");
      print("🛡️ get_Token: $token");
      print("📦 get_Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        List<serviceTypeModel> serviceType = jsonList
            .map(
              (json) => serviceTypeModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        return serviceType;
      } else {
        print("Error fetching service type serialBook: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception while getting service type serialBook: $e");
      return [];
    }
  }
}
