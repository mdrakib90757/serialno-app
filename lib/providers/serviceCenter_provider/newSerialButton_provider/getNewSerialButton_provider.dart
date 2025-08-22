


import 'package:flutter/material.dart';
import 'package:serialno_app/api/serviceCenter_api/newSerialButton_servicecenter/newSerialButton.dart';
import 'package:serialno_app/model/serialService_model.dart';


class GetNewSerialButtonProvider with ChangeNotifier {

  final NewSerialButtonService _newSerialButtonService = NewSerialButtonService();


  // List<SerialModel> _serials = [];
  // List<SerialModel> get serials => _serials;


  List<SerialModel> _allSerials = [];


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<SerialModel> get queueSerials => _allSerials.where((serial) => serial.status != 'Served').toList();

  List<SerialModel> get servedSerials => _allSerials.where((serial) => serial.status == 'Served').toList();


  Future<void> fetchSerialsButton(String serviceCenterId, String date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allSerials = await _newSerialButtonService.getNewSerialButton(serviceCenterId, date);

    } catch (e) {
      _errorMessage = e.toString();
      _allSerials = [];
    }


    _isLoading = false;
    notifyListeners();



  }
  void clearData() {
    //_serials = [];
    _isLoading = false;
    _errorMessage = null;


    notifyListeners();
    print("SerialListProvider cleared!");
  }
}