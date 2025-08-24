

import 'dart:convert';

import 'package:serialno_app/core/api_client.dart';
import 'package:serialno_app/model/AddUser_serviceCenterModel.dart';
import 'package:serialno_app/request_model/serviceCanter_request/addUser_serviceCenterRequest/addUser_ServiceCenter_request.dart';

class AddUserServiceCenter {

  Future<dynamic>AddUserButton(
      AddUserRequest userRequest,
      String companyId,
      )async{
    String body=jsonEncode(userRequest.toJson());
    final response = ApiClient().post("/serial-no/companies/$companyId/service-men",body: body);
  return response;
  }


Future<List<AddUserModel>> fetchAddUser(
    String companyId
    )async{
    try{
      final response = await ApiClient().get("/serial-no/companies/$companyId/service-men") as List;
      List<AddUserModel> users = response
          .map((userJson) => AddUserModel.fromJson(userJson as Map<String, dynamic>))
          .toList();
      return users;

    }catch(e){
      print("❌ Error fetching company users: $e");
      return[];
    }
}

}