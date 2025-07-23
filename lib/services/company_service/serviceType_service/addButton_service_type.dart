

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:serial_no_app/utils/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddbuttonServiceType with ChangeNotifier{

  // String? _token;
  // String? get token=>_token;

  bool _isLoading=false;
  bool get isLoading=>_isLoading;


  Future<bool>AddButtonService_type({
    String? id,
    required String name,
    required String price,
    required String defaultAllocatedTime,
    String? companyId,
    String?serviceCenterId,

  })async{
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    print("AddButtonToken${token}");
    print(ApiConfig.addButton_serviceType_endtpoint);
    final int? priceInt = int.tryParse(price);
    final int? timeInt = int.tryParse(defaultAllocatedTime);

    if (priceInt == null || timeInt == null) {
      debugPrint("Invalid number format for price or time");
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try{
      final response = await http.post(Uri.parse(
          ApiConfig.addButton_serviceType_endtpoint
      ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ${token}"
          },
          body:  jsonEncode({
            "name":name,
            "price":priceInt,
            "defaultAllocatedTime":timeInt,
            "companyId":companyId,
            "serviceCenterId":serviceCenterId,
          })
      );
      print("Get AddButton ServiceType ${
          jsonEncode({
            "id":id,
            "name":name,
            "price":price,
            "defaultAllocatedTime":defaultAllocatedTime,
            "companyId":companyId,
            "serviceCenterId":serviceCenterId??"N/A"
          })
      }");

      _isLoading = false;
      notifyListeners();

      print(response.body);
      print("AddButtonToken_ServiceType${token}");

      if(response.statusCode==200|| response.statusCode == 201){
        debugPrint("✅ AddButton POST Success: ${response.body}");
        return true;
      }else{
        debugPrint("❌ Add_button POST Failed: ${response.statusCode}");
        debugPrint("❗ Body: ${response.body}");
        return false;
      }


    }catch(e){
      _isLoading = false;
      notifyListeners();
      debugPrint("❌ Error: $e");
      return false;
    }
  }
}


