import 'dart:convert';

import 'package:serialno_app/core/api_client.dart';
import 'package:serialno_app/model/serviceCenter_model.dart';
import 'package:serialno_app/request_model/serviceCanter_request/addButton_request/add_Button_request.dart';

class AddButtonApi {
  //AddButton
  Future<dynamic> addButton_service(
    AddButtonRequest requestData,
    String companyId,
  ) async {
    String body = jsonEncode(requestData.toJson());
    final response = ApiClient().post(
      "/serial-no/companies/$companyId/service-centers",
      body: body,
    );
    return response;
  }

  //Get AddButton
  Future<List<ServiceCenterModel>> GetAddButton(String companyId) async {
    try {
      var response =
          await ApiClient().get(
                "/serial-no/companies/$companyId/service-centers",
              )
              as List;
      List<ServiceCenterModel> ButtonData = response
          .map(
            (data) => ServiceCenterModel.fromJson(data as Map<String, dynamic>),
          )
          .toList();
      return ButtonData;
    } catch (e) {
      print("Error fetching or parsing GetAddButton - : $e");
      return [];
    }
  }

  Future<void> deleteServiceCenter(String companyId, String Id) async {
    try {
      await ApiClient().delete(
        "/serial-no/companies/$companyId/service-centers/$Id",
      );
    } catch (e) {
      print("❌ Error in ServiceCenter deleteUser API: $e");
      rethrow;
    }
  }
}
