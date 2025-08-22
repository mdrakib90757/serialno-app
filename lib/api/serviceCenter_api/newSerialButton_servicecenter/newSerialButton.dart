
import 'dart:convert';

import 'package:serialno_app/core/api_client.dart';
import 'package:serialno_app/model/serialService_model.dart';
import 'package:serialno_app/request_model/serviceCanter_request/newSerialButton_request/newSerialButton_request.dart';


class NewSerialButtonService{

  Future<dynamic>NewSerialButton(NewSerialButtonRequest serialRequest, String serviceCenterId )async{
    String body=jsonEncode( serialRequest.toJson());
    final response= await ApiClient().post("/serial-no/service-centers/$serviceCenterId/services/book",body: body);
  return response;
  }


  Future<List<SerialModel>>getNewSerialButton(String serviceCenterId, String date)async{
    try{
      final Map<String, String> queryParameters = {
        'date': date,
      };
      var response= await ApiClient().get("/serial-no/service-centers/$serviceCenterId/services",queryParameters: queryParameters) as List;
    List<SerialModel>NewButtonData=response.map((data)=>SerialModel.fromJson(data)).toList();
    return NewButtonData;
    }catch(e){
      print("Error fetching or parsing NewButtonData - : $e");
      return [];
    }
  }

}


