

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:serial_no_app/utils/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class postAddButtonServiceCenter with ChangeNotifier{

  // String? _token;
  // String? get token=>_token;

  bool _isLoading=false;
  bool get isLoading=>_isLoading;


  Future<bool>AddButtonService({
     String? id,
    required String name,
    required String hotlineNo,
    required String? email,
     String? companyId,

})async{
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    print("AddButtonToken${token}");
    print(ApiConfig.addButton_serviceCenter_endpoint);

    try{
      final response = await http.post(Uri.parse(
        ApiConfig.addButton_serviceCenter_endpoint
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}"
      },
        body:  jsonEncode({
          "id":id,
          "name":name,
          "hotlineNo":hotlineNo,
          "email":email,
          "companyId":companyId,
        })
      );
      print(jsonEncode({
        "id":id,
        "name":name,
        "hotlineNo":hotlineNo,
        "email":email,
        "companyId":companyId,
      }));
      _isLoading = false;
      notifyListeners();

      print(response.body);
      print("AddButtonToken${token}");

      if(response.statusCode==200){
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



// {
// "id": "32bccf5a-4fcf-4920-89d9-10b2a4d7eea8",
// "name": "rabbi",
// "hotlineNo": "01601711260",
// "email": "maruf@gmail.com",
// "companyId": "c9065134-50f3-42ff-9fdc-bbd00ab3fdd9"
// }