


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/config/api_config.dart';
import 'package:http/http.dart' as http;

class ChangePasswordService{


  Future<bool>UpdatePasswors({
    required String currentPassword,
    required String newPassword
  })async{

    final prefs=await SharedPreferences.getInstance();
    final token= prefs.getString("accessToken");
    print("token:- ${token}");
    try{
      final response= await http.post(Uri.parse(
        ApiConfig.changePassword_endpoint
      ),

        headers: {
         "content-type":"application/json",
          "Authorization":"Bearer ${token}"
        },
        body: jsonEncode({
            "currentPassword":currentPassword,
          "newPassword":newPassword,
          })

      );
      print(jsonEncode({
        "currentPassword":currentPassword,
        "newPassword":newPassword,
      }));

      print(response.body);

      if(response.statusCode==200){
        debugPrint("Password Change success${response.body}");
      return true;
      }else{
        debugPrint("❌ Password update filed${response.statusCode}");
        debugPrint("! Body:${response.body}");
      return false;
      }


    }catch(e){
      debugPrint("Error ${e}");
      return false;
    }



  }
}