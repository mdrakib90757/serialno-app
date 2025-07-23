import 'dart:convert';

import 'package:serial_no_app/model/service_type_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

import '../../../utils/config/api_config.dart';

class getAddButtonServiceType{

  Future<List<ServiceTypeModel>>getAddButton_ServiceType()async{

    final prefs= await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");
    if (token == null) {
      print("❌ Token not found in SharedPreferences for GET request.");
      return [];
    }

    try{
      final response = await http.get(Uri.parse(
          ApiConfig.getAddButton_service_Type_endpoint),
          headers: {
            "content-type":"application/json",
            "Authorization": "Bearer $token"
          }
      );
      print("📡 get_addButtonAPI: ${ ApiConfig.getAddButton_service_Type_endpoint}");
      print("🛡️ get_Token: $token");
      print("📦 get_Response: ${response.statusCode} - ${response.body}");

      if(response.statusCode==200){
        final List<dynamic> jsonList = jsonDecode(response.body);
        List<ServiceTypeModel> serviceType = jsonList
            .map((json) => ServiceTypeModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return serviceType;
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
