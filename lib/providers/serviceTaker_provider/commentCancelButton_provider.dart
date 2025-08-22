

import 'package:flutter/cupertino.dart';
import 'package:serialno_app/services/customer_service/serviceTaker_homeScreen/comment_cancelButton.dart';

class CommentCancelButtonProvider with ChangeNotifier{

  final CommentCancelButtonService _cancelButtonService = CommentCancelButtonService();

  bool _isLoading=false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  Future<bool>commentCancelButton({
    required String? id,
    required String? serviceCenterId,
    required String serviceTypeId,
    required String comment,
    required String status,
  })async{
    _isLoading=true;
    _errorMessage = null;
    notifyListeners();


    final success = await _cancelButtonService.putCancelButton(
        id: id,
        serviceCenterId: serviceCenterId,
        serviceTypeId: serviceTypeId,
      comment: comment,
      status: status
    );

    _isLoading = false;
    if(success){
      _errorMessage="Failed to commentCancelButton. Please try again.";
    }
    notifyListeners();
    return success;
  }



}