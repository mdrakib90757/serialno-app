





import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/serviceCenter_model.dart';
import '../../../utils/config/api.dart';



class Servicecenter_Bookserial_service{

  Future<List<ServiceCenterModel>>ServiceCenter_bookserialService(String companyId)async{

    final prefs= await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");
    if (token == null) {
      print("❌ Token not found in SharedPreferences for GET request.");
      return [];
    }
    final String urlString = '${apiConfig.baseUrl}/companies/$companyId/service-centers?';
    final url= Uri.parse(urlString);
    print("ServiceCenter_bookSerial -  ${url}");

    try{
      final response = await http.get(
          url,
          headers: {
            "content-type":"application/json",
            "Authorization": "Bearer $token"
          }
      );

      print("🛡️ get_Token: $token");
      print("📦 get_Response: ${response.statusCode} - ${response.body}");

      if(response.statusCode==200){
        final List<dynamic> jsonList = jsonDecode(response.body);
        List<ServiceCenterModel> serviceCenters = jsonList
            .map((json) => ServiceCenterModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return serviceCenters;
      }else{
        print("Error fetching service centers serial book : ${response.body}");
        return [];
      }

    }catch(e){
      print("Exception while getting service centers serial book: $e");
      return [];
    }
  }

}
