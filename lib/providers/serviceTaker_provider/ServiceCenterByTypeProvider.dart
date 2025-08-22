import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import '../../model/serviceCenter_model.dart';
import '../../utils/config/api.dart';

class ServiceCenterByTypeProvider with ChangeNotifier {
  List<ServiceCenterModel> _serviceCenters = [];
  bool _isLoading = false;

  List<ServiceCenterModel> get serviceCenters => _serviceCenters;
  bool get isLoading => _isLoading;

  Future<void> fetchServiceCenters(String businessTypeId) async {
    _isLoading = true;
    _serviceCenters = [];
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      print(" ServiceCenterByTypeProvider - ${token}");

      final url = Uri.parse(
        '${apiConfig.baseUrl}/service-centers?businessTypeId=$businessTypeId',
      );

      print('🚀 [New Provider] Calling: $url');
      print("ServiceCenterByTypeProvider - ${businessTypeId}");
      print("--- Starting API call NOW ---");
      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              print("API Call TIMED OUT after 30 seconds!");
              return http.Response(
                'Server took too long to respond.',
                408,
              ); // Request Timeout status code
            },
          );
      print("--- API call FINISHED ---");
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _serviceCenters = data
            .map((json) => ServiceCenterModel.fromJson(json))
            .toList();
        print(
          "✅ Data successfully parsed: ${_serviceCenters.length} items found.",
        );
      } else {
        throw Exception(
          'Failed to load service centers. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      print('CRITICAL ERROR in ServiceCenterByTypeProvider: $e ');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _serviceCenters = [];
    notifyListeners();
  }
}
