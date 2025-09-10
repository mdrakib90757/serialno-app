import 'dart:convert';

import 'package:serialno_app/request_model/serviceCanter_request/add_service_center_service_type_request/service_center_service_type_request.dart';

import '../../../core/api_client.dart';
import '../../../model/service_type_model.dart';
import '../../../request_model/serviceCanter_request/update_service_center_service_type_request/update_service_center_service_type_request.dart';

class service_center_service_type_service {
  Future<dynamic> SecondServiceType(
    String serviceCenterId,
    add_service_center_service_type_request requestData,
  ) async {
    String body = jsonEncode(requestData.toJson());
    final response = await ApiClient().post(
      "/serial-no/service-centers/$serviceCenterId/service-types",
      body: body,
    );
    return response;
  }

  //Get AddButton
  Future<List<serviceTypeModel>> second_getAddButtonServiceType(
    String serviceCenterId,
  ) async {
    try {
      var response =
          await ApiClient().get(
                "/serial-no/service-centers/$serviceCenterId/service-types",
              )
              as List;
      List<serviceTypeModel> ButtonData = response
          .map(
            (data) => serviceTypeModel.fromJson(data as Map<String, dynamic>),
          )
          .toList();
      return ButtonData;
    } catch (e) {
      print("Error fetching or parsing GetAddButtonServiceType - : $e");
      return [];
    }
  }

  Future<dynamic> update_service_center_service_type_service(
    update_service_center_service_type_request request,
    String serviceCenterId,
  ) async {
    try {
      String body = jsonEncode(request.toJson());
      final response = await ApiClient().put(
        "serial-no/service-centers/$serviceCenterId/service-types",
        body: body,
      );
      return response;
    } catch (e) {
      print(e);
    }
  }
}
