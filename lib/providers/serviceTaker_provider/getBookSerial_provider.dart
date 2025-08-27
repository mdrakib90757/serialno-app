import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serialno_app/model/mybooked_model.dart';
import 'package:serialno_app/services/customer_service/serviceTaker_homeScreen/getBookSerial_service.dart';

class GetBookSerialProvider with ChangeNotifier {
  final GetBookSerial_service _getBookSerial_service = GetBookSerial_service();

  List<MybookedModel> _bookSerialList = [];
  List<MybookedModel> get bookSerialList => _bookSerialList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchgetBookSerial(String date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookSerialList = await _getBookSerial_service.getbookSerialButtonService(
        date,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _bookSerialList = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
