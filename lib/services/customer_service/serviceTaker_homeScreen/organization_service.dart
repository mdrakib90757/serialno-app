import 'dart:convert';

import 'package:serialno_app/model/organization_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/config/api.dart';

class OrganizationService {
  String? errorMessage;

  Future<List<OrganizationModel>> fetchOrganization({
    required String businessTypeId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");
    print("OrganizationToken - ${token}");

    if (token == null) {
      errorMessage = "Authentication token not found. Please log in again.";
      throw Exception(errorMessage);
    }
    final String urlString =
        '${apiConfig.baseUrl}/organizations?businessTypeId=$businessTypeId';
    final url = Uri.parse(urlString);
    print("Organization Api Url - ${url}");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        List<OrganizationModel> organizations = responseData
            .map((data) => OrganizationModel.fromJson(data))
            .toList();

        return organizations;
      } else {
        // যদি কোনো সমস্যা হয়
        errorMessage =
            'Failed to load organizations. Status code: ${response.statusCode}';
        print('Error: ${response.body}');
        throw Exception(errorMessage);
      }
    } catch (e) {
      errorMessage = 'An unexpected error occurred: $e';
      print(errorMessage);
      throw Exception(errorMessage);
    }
  }
}
