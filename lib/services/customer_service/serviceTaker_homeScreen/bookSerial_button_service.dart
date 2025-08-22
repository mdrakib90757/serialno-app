

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/config/api.dart';
import 'package:http/http.dart' as http;

class BookSerialButtonService{
  String? lastErrorMessage;

  Future<bool>bookSerialButton({
    required String businessTypeId,
    required String serviceCenterId,
    required String serviceTypeId,
    required String serviceDate,
    required String serviceTaker,
    required String contactNo,
    required String name,
     String? organizationId,
    required bool forSelf,
})async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      debugPrint("❌ Token not found for creating serial.");
      return false;
    }

    final url = Uri.parse('${Api.baseUrl}/api/serial-no/service-centers/$serviceCenterId/services/book');
    print("BookSerialService - ${url}");

    try{
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "businessTypeId":businessTypeId,
          "serviceCenterId":serviceCenterId,
          "serviceTypeId":serviceTypeId,
          "serviceDate":serviceDate,
          "serviceTaker":serviceTaker,
          "contactNo":contactNo,
          "name":name,
          "organizationId":organizationId,
          "forSelf":forSelf,
        })
      );

      print("BookSerialService body ${
          jsonEncode({
            "businessTypeId":businessTypeId,
            "serviceCenterId":serviceCenterId,
            "serviceTypeId":serviceTypeId,
            "serviceDate":serviceDate,
            "serviceTaker":serviceTaker,
            "contactNo":contactNo,
            "name":name,
            "organizationId":organizationId,
            "forSelf":forSelf,
          })
      }");

      if(response.statusCode==201 || response.statusCode==200){
        debugPrint("✅ New bookSerial successfully: ${response.body}");
        return true;
      }else{

        if (response.body.isNotEmpty) {
          try {
            final errorData = json.decode(response.body);
            lastErrorMessage = errorData['errorMessage'] ?? 'An unknown server error occurred.';
          } catch (e) {
            // যদি JSON পার্স করতে সমস্যা হয়
            lastErrorMessage = "Invalid response from server.";
          }
        }
        return false; //

      }

    }catch(e){
      lastErrorMessage = "Could not connect to the server.";
      return false;
    }

}


}