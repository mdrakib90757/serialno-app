import 'package:flutter/material.dart';
import '../../../../api/serviceCenter_api/addButton_serviceType/addbutton_serviceType.dart';

class DeleteServiceTypeProvider with ChangeNotifier {
  final AddButtonServiceType _api = AddButtonServiceType();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> delete_serviceType(String companyId, String Id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _api.deleteServiceType(companyId, Id);
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
