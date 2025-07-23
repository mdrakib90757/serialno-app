



import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/profile_user_model.dart';
import 'package:http/http.dart' as http;

import '../utils/config/api_config.dart';

class GetProfileServices{


Future<profile_UserModel?>getupdateProfile(String token)async{

    final prefs= await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");

  try{
    final response= await http.get(
        Uri.parse(ApiConfig.getprofile_endpoint),
      headers: {
       "content-type":"application/json",
        "Authorization": "Bearer $token"
      }
    );
    print("📡 API: ${ApiConfig.getprofile_endpoint}");
    print("🛡️ Token: $token");
    print("📦 Response: ${response.statusCode} - ${response.body}");

    if(response.statusCode==200){
      final Map<String,dynamic> jsonMap = jsonDecode(response.body);

      return profile_UserModel.fromJson(jsonMap);

    }else{
      print("Error ${response.body} ${response.statusCode}");
      return null;
    }

  }catch(e){
    print("Exception ${e}");
    return null;
  }
}


}




