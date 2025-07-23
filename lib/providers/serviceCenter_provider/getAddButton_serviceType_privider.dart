




import 'package:flutter/material.dart';
import 'package:serial_no_app/model/serviceCenter_model.dart';
import 'package:serial_no_app/model/service_type_model.dart';
import 'package:serial_no_app/services/company_service/serviceType_service/get_addButton_serviceType.dart';
import 'package:serial_no_app/services/company_service/serviceCenter_service/getaddbutton_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth_providers.dart';

class GetAddButton_serviceType_Provider with ChangeNotifier{
  String ? _token;
  String? get token => _token;

  List<ServiceTypeModel> _serviceTypeList = [];
  List<ServiceTypeModel> get serviceTypeList => _serviceTypeList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //get token
  Future<void>getToken()async{
    final prefs= await SharedPreferences.getInstance();
    final token = await AuthProvider().getToken();
    _token=prefs.getString("accessToken");
    print("Get_Token ${token}");
    debugPrint("✅ GetAddButtonServiceType_Provider successfully read token: ${_token != null}");

  }

  Future<void>fetchGetAddButton_ServiceType()async{
    _isLoading = true;
    notifyListeners();

    await getToken();

    if (_token != null) {
      debugPrint("🚀 Fetching service centers with a valid token...");

      _serviceTypeList = await getAddButtonServiceType().getAddButton_ServiceType();

    }else{
      debugPrint("❌ Token is null. Can't fetch service centers.");
    }
    _isLoading = false;
    notifyListeners();

  }


  void clearData(){
    _serviceTypeList=[];
    _token=null;
    _isLoading = false;

    notifyListeners();
    print("GetAddButtonServiceTypeProvider cleared!");
  }



}