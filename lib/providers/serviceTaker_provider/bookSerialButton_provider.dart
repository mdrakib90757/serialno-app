import 'package:flutter/cupertino.dart';
import 'package:serialno_app/services/customer_service/serviceTaker_homeScreen/bookSerial_button_service.dart';

class bookSerialButton_provider with ChangeNotifier {
  final BookSerialButtonService bookSerialButtonService =
      BookSerialButtonService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> fetchBookSerialButton({
    required String businessTypeId,
    required String serviceCenterId,
    required String serviceTypeId,
    required String serviceDate,
    required String serviceTaker,
    required String contactNo,
    required String name,
    required String? organizationId,
    required bool forSelf,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await bookSerialButtonService.bookSerialButton(
      businessTypeId: businessTypeId,
      serviceCenterId: serviceCenterId,
      serviceTypeId: serviceTypeId,
      serviceDate: serviceDate,
      serviceTaker: serviceTaker,
      contactNo: contactNo,
      name: name,
      organizationId: organizationId,
      forSelf: forSelf,
    );
    _isLoading = false;
    if (!success) {
      _errorMessage = bookSerialButtonService.lastErrorMessage;
    }

    notifyListeners();
    return success;
  }
}
