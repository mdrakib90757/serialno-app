

import 'dart:convert';

import 'package:serialno_app/core/api_client.dart';
import 'package:serialno_app/model/serialService_model.dart';
import 'package:serialno_app/request_model/serviceCanter_request/status_UpdateButtonRequest/status_updateButtonRequest.dart';

class StatusUpdateButtonService{

  Future<dynamic>statusButton(StatusButtonRequest statusRequest, String serviceCenterId,String serviceId,) async{
String body = jsonEncode(statusRequest.toJson());
final response= await ApiClient().put("/serial-no/service-centers/$serviceCenterId/services/$serviceId",body: body);
 return response;
  }




  Future<List<SerialModel>>GetStatusButtonService( String serviceCenterId,
      String? date,)async {
    try {
      final Map<String, String> queryParameters = {
        'date': ?date,
      };
      var response = await ApiClient().get("/serial-no/service-centers/$serviceCenterId/services",queryParameters: queryParameters) as List;
      List<SerialModel>StatusButtonData = response.map((data) =>
          SerialModel.fromJson(data as Map<String, dynamic>)).toList();
      return StatusButtonData;
    } catch (e) {
      print("Error fetching or parsing GetEditButton - : $e");
      return [];
    }
  }
}