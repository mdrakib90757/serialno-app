

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:serial_no_app/utils/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateServicetype {



  Future<bool>Update_Servicetype({
    required String id,
    required String name,
    required String price,
    required String defaultAllocatedTime,

  })async{
    final prefs= await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");

    print("EditButtonToken${token}");

    print(ApiConfig.addButton_serviceType_endtpoint);

    final int? priceInt = int.tryParse(price);
    final int? timeInt = int.tryParse(defaultAllocatedTime);

    final String dynamicUrl="${
        ApiConfig.put_update_serviceType}/$id";

    print("ServiceType Id -${id}");

    try {
      final response = await http.put(Uri.parse(
          dynamicUrl),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "name": name,
            "price": priceInt,
            "defaultAllocatedTime": timeInt,
          })
      );
      print('Request Body: '
          '${jsonEncode({
        "name": name,
        "price": priceInt,
        "defaultAllocatedTime": timeInt})}'
      );

      if (response.statusCode == 200 || response.statusCode==204) {
        print('✅ Update successful for ID: $id');
        debugPrint("✅ Edit Update Success: ${response.body}");
        return true;

      } else {
        debugPrint("❌ edit Update Failed: ${response.statusCode}");
        debugPrint("❗ Body: ${response.body}");
        return false;
      }
    }catch (e) {
      print('Error during PUT request: $e');
      return false;
    }
  }
}