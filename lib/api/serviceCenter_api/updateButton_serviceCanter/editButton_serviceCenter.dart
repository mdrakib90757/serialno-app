import 'dart:convert';

import 'package:serialno_app/core/api_client.dart';
import 'package:serialno_app/request_model/serviceCanter_request/editButton_request/edit_Button_request.dart';

import '../../../model/serviceCenter_model.dart';

class EditButtonApi {
  Future<dynamic> EditButtonService(
    EditButtonRequest edit_request,
    String companyId,
    String id,
  ) async {
    String body = jsonEncode(edit_request.toJson());
    final response = ApiClient().put(
      "/serial-no/companies/$companyId/service-centers/$id",
      body: body,
    );
    return response;
  }

  //Get EditButton
  Future<List<ServiceCenterModel>> GetEditButtonService(
    String companyId,
  ) async {
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
      print("Error fetching or parsing GetEditButton - : $e");
      return [];
    }
  }
}
