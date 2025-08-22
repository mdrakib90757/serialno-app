

import 'package:flutter/cupertino.dart';
import 'package:serialno_app/services/customer_service/serviceTaker_homeScreen/update_bookSerial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateBookSerialProvider with ChangeNotifier{

  final UpdateBookSerialService _updateBookSerial = UpdateBookSerialService();

  bool _isLoading=false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  Future<bool>update_bookSerial({
    required String? id,
    required String? serviceCenterId,
    required String serviceTypeId,
    required bool forSelf,
    required String name,
    required String contactNo,
})async{
    _isLoading=true;
    _errorMessage = null;
   notifyListeners();


   final success = await _updateBookSerial.updateBookSerial(
       id: id,
       serviceCenterId: serviceCenterId,
       serviceTypeId: serviceTypeId,
       forSelf: forSelf,
       name: name,
       contactNo: contactNo
   );

    _isLoading = false;
    if(success){
      _errorMessage="Failed to StatusButton. Please try again.";
    }
    notifyListeners();
    return success;
  }



}