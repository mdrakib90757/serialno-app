import 'package:flutter/material.dart';
import 'package:serialno_app/services/customer_service/serviceTaker_homeScreen/serviceCenter_bookSerial.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/serviceCenter_model.dart';
import '../auth_provider/auth_providers.dart';

class serviceCenter_serialBookProvider with ChangeNotifier {
  final Servicecenter_Bookserial_service _servicecenter_bookserial_service =
      Servicecenter_Bookserial_service();

  String? _token;
  String? get token => _token;

  List<ServiceCenterModel> _serviceCenterList = [];
  List<ServiceCenterModel> get serviceCenterList => _serviceCenterList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? selectedServiceCenterId;

  void selectCenter(String id) {
    selectedServiceCenterId = id;
    notifyListeners();
  }

  //get token
  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("accessToken");
    print("Get_Token ${token}");
    debugPrint(
      "serviceCenter_serialBookProvider successfully read token: ${_token != null}",
    );
  }

  Future<void> fetchserviceCnter_serialbook(String companyId) async {
    _isLoading = true;
    notifyListeners();

    await getToken();

    if (companyId.isEmpty) {
      print("Company ID is missing. Can't fetch service centers.");
      _isLoading = false;
      notifyListeners();
      return;
    }

    debugPrint(" Fetching service centers for company: $companyId");
    _serviceCenterList =
        await _servicecenter_bookserial_service.ServiceCenter_bookserialService(
          companyId,
        );

    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _serviceCenterList = [];
    _token = null;
    _isLoading = false;

    notifyListeners();
    print("serviceCenter_serialBookProvider cleared!");
  }
}
