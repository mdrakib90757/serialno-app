




import 'package:flutter/material.dart';
import 'package:serialno_app/services/customer_service/serviceTaker_homeScreen/serviceType_bookSerial_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/service_type_model.dart';
import '../auth_provider/auth_providers.dart';

class serviceTypeSerialbook_Provider with ChangeNotifier {

  final serviceTypeserialbook_service _typeserialbook_service=serviceTypeserialbook_service();

  String ? _token;
  String? get token => _token;

  List<serviceTypeModel> _serviceTypeList = [];
  List<serviceTypeModel> get serviceTypeList => _serviceTypeList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //get token
  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
   // final token = await AuthProvider()._getToken;
    _token = prefs.getString("accessToken");
    print("Get_Token ${token}");
    debugPrint(
        "✅ serviceTypeSerial_book_Provider successfully read token: ${_token !=
            null}");
  }

  Future<void> serviceType_serialbook(String companyId) async {
    _isLoading = true;
    notifyListeners();

    await getToken();

    if (companyId.isEmpty) {
      print("❌ companyId ID is missing. Cannot fetch service types.");
      _serviceTypeList = [];
      _isLoading = false;
      notifyListeners();
      return;
    }
    debugPrint("🚀 Fetching service centers with a valid token...");

    _serviceTypeList =
    await _typeserialbook_service.fetchServiceType_serialbook(companyId);
    _isLoading = false;
    notifyListeners();
  }


  void clearData() {
    _serviceTypeList = [];
    _token = null;
    _isLoading = false;

    notifyListeners();
    print("serviceTypeSerial_book_Provider cleared!");
  }


}