import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/api/serviceCenter_api/roles_service_center/roles_service_center.dart';
import 'package:serialno_app/model/roles_model.dart';

class RolesProvider with ChangeNotifier {
  final RolesApi _rolesApi = RolesApi();

  RolesModel? _rolesModel;
  bool _isLoading = false;
  String? _errorMessage;

  RolesModel? get roles => _rolesModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRoles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _rolesModel = await _rolesApi.RolesInfo();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Failed to load Roles details: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
