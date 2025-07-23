import 'package:flutter/material.dart';

import '../../services/company_service/serviceCenter_service/serialServiceCenter.dart';


class SerialProvider with ChangeNotifier {

  final SerialService _serialService = SerialService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> createSerial({
    required String serviceCenterId,
    required String serviceCenterName,
    required String serviceTypeId,
    required String serviceDate,
    required String name,
    required String contactNo,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await _serialService.createNewSerial(
      serviceCenterName: serviceCenterName,
      serviceTypeId: serviceTypeId,
      serviceDate: serviceDate,
      name: name,
      contactNo: contactNo,
      serviceCenterId: serviceCenterId,

    );

    _isLoading = false;
    if (!success) {
      _errorMessage = "Failed to create serial. Please try again.";
    }

    notifyListeners();
    return success;
  }
}

