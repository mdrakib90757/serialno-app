import 'package:flutter/material.dart';

import '../../model/serialService_model.dart';
import '../../services/company_service/serviceCenter_service/getSerial_centerService_service.dart';


class SerialListProvider with ChangeNotifier {

  final GetSerialsService _serialsService = GetSerialsService();

  List<SerialModel> _serials = [];
  List<SerialModel> get serials => _serials;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSerials(String serviceCenterId, String date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _serials = await _serialsService.fetchSerialsByCenterAndDate(serviceCenterId, date);


    } catch (e) {
      _errorMessage = e.toString();
      _serials = [];
    }


    _isLoading = false;
    notifyListeners();



  }
  void clearData() {
    _serials = [];
    _isLoading = false;
    _errorMessage = null;


    notifyListeners();
    print("SerialListProvider cleared!");
  }
}