

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:serial_no_app/utils/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edit_updatebuttonservice {



  Future<bool>UpadetButtonService({
    required String id,
    required String name,
  required String hotlineNo,
  required String email,

})async{
    final prefs= await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");
    print("Edit_Update${token}");

    final String dynamicUrl="${
        ApiConfig.put_Edit_update_serviceCenter_endpoint_base_endpoint}/$id";

    try {
      final response = await http.put(Uri.parse(
          dynamicUrl),
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "name": name,
            "hotlineNo": hotlineNo,
            "email": email,
          })
      );
      print('Request Body: '
          '${jsonEncode({
        "name": name,
        "hotlineNo": hotlineNo,
        "email": email})}'
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