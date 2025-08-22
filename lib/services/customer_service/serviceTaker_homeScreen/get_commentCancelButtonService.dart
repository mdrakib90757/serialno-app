


import 'dart:convert';

import 'package:serialno_app/model/mybooked_model.dart';
import 'package:serialno_app/utils/config/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetCommentCancelButtonService{


  Future<List<MybookedModel>>getCommentCancelButton(
      String? date

      ) async{

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      print("❌ Token not found in GetCommentCancelButtonService");
      return [];

    }

    final url = Uri.parse("${apiConfig.baseUrl}/my-booked-services?date=$date");
    print("GetCommentCancelButtonService - ${url}");


    try{
      final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }
      );
      print(response.body);
      if(response.statusCode==200){
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => MybookedModel.fromJson(json as Map<String, dynamic>))
            .toList();

      }else {
        print("Error fetching GetCommentCancelButtonService: ${response.statusCode} - ${response.body}");
        print("GetCommentCancelButtonService${response.body}");
        throw Exception('Failed to load GetCommentCancelButtonService');
      }

    }catch (e) {
      print("Exception during fetching GetCommentCancelButtonService serials:-- $e");
      throw Exception('Failed to load GetCommentCancelButtonService due to an exception');
    }
  }

}