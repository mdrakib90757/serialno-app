import 'package:flutter/material.dart';
import 'package:serialno_app/api/serviceCenter_api/addButton_ServiceCenter_api/addButton_api.dart';
import 'package:serialno_app/api/serviceCenter_api/addUser_serviceCenter/addUser_serviceCenter.dart';

class DeleteServiceCenterProvider with ChangeNotifier {
  final AddButtonApi _api = AddButtonApi();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> delete_serviceCenter(String companyId, String Id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _api.deleteServiceCenter(companyId, Id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
