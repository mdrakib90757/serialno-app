





import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/serviceCenter_model.dart';
import '../../../utils/config/api_config.dart';


class getAddButtonService{

  Future<List<ServiceCenterModel>>getAddButton()async{

    final prefs= await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");
    if (token == null) {
      print("❌ Token not found in SharedPreferences for GET request.");
      return [];
    }

    try{
      final response = await http.get(Uri.parse(
        ApiConfig.get_addButton_serviceCenter_endpoint),
      headers: {
        "content-type":"application/json",
        "Authorization": "Bearer $token"
      }
      );
      print("📡 get_addButtonAPI: ${ ApiConfig.get_addButton_serviceCenter_endpoint}");
      print("🛡️ get_Token: $token");
      print("📦 get_Response: ${response.statusCode} - ${response.body}");

      if(response.statusCode==200){
        final List<dynamic> jsonList = jsonDecode(response.body);
        List<ServiceCenterModel> serviceCenters = jsonList
            .map((json) => ServiceCenterModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return serviceCenters;
      }else{
        print("Error fetching service centers: ${response.body}");
        return [];
      }

    }catch(e){
      print("Exception while getting service centers: $e");
      return [];
    }
    }

  }
