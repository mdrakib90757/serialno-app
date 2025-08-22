
import 'package:flutter/material.dart';
import 'package:serialno_app/api/serviceCenter_api/statusButton_serviceCenter/status_updateButton_service.dart';
import 'package:serialno_app/request_model/serviceCanter_request/status_UpdateButtonRequest/status_updateButtonRequest.dart';
import '../../../services/company_service/serviceCenter_service/status_updateButton_service.dart';

class statusUpdateButton_provder with ChangeNotifier{
  final StatusUpdateButtonService _statusUpdateButtonService =StatusUpdateButtonService();


bool _isLoading=false;
bool get isLoading => _isLoading;

String? _errorMessage;
String? get errorMessage => _errorMessage;


Future<bool> updateStatus(
StatusButtonRequest buttonRequest, String serviceCenterId,String serviceId
)async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    await _statusUpdateButtonService.statusButton(
        buttonRequest,
        serviceCenterId,
        serviceId
    );
    _isLoading = false;
    notifyListeners();
   return true;

  }catch(e){
    _errorMessage = e.toString().replaceAll("Exception: ", "").trim();
    _isLoading = false;
    notifyListeners();
    return false;
  }
}


}