import 'package:flutter/cupertino.dart';
import 'package:serialno_app/services/customer_service/serviceTaker_homeScreen/organization_service.dart';

import '../../model/organization_model.dart';

class OrganizationProvider with ChangeNotifier {
  final OrganizationService _organizationService = OrganizationService();

  List<OrganizationModel> _organizations = [];
  List<OrganizationModel> get organizations => _organizations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> get_Organization({required String businessTypeId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _organizations = await _organizationService.fetchOrganization(
        businessTypeId: businessTypeId,
      );
    } catch (e) {
      _errorMessage = _organizationService.errorMessage ?? e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _organizations = [];
    notifyListeners();
  }
}
