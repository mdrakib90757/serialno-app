





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serialno_app/model/mybooked_model.dart';
import 'package:serialno_app/services/customer_service/serviceTaker_homeScreen/getBookSerial_service.dart';

import '../../services/customer_service/serviceTaker_homeScreen/get_updateBookSerial.dart';

class GetUpdate_bookSerialProvider with ChangeNotifier{

  final Get_UpdateBookSerial_service _get_updateBookSerial_service = Get_UpdateBookSerial_service();

  List<MybookedModel>_bookSerialList=[];
  List<MybookedModel> get bookSerialList=>_bookSerialList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  Future<void>fetch_updateBookSerial(String date)async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{

      _bookSerialList = await _get_updateBookSerial_service.get_UpdatebookSerial_Service(date);
    }catch(e){
      _errorMessage = e.toString();
      _bookSerialList=[];
    }
    _isLoading = false;
    notifyListeners();

  }


}