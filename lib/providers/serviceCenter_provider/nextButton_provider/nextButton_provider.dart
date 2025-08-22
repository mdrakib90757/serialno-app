import 'package:flutter/material.dart';
import 'package:serialno_app/api/serviceCenter_api/nextButton_serviceCenter/nextButton_service.dart';

class nextButtonProvider with ChangeNotifier {
  final NextButtonService _nextButtonService = NextButtonService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _serviceData;
  Map<String, dynamic>? get serviceData => _serviceData;

  Future<bool> NextButton({
    required String serviceCenterId,
    required String date,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _serviceData = null;
    notifyListeners();

    try {
      final responseData = await _nextButtonService.nextButton(
        serviceCenterId: serviceCenterId,
        date: date,
      );
      if (responseData != null) {
        _serviceData = responseData;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "Failed to get next service. Please try again.";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "").trim();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
