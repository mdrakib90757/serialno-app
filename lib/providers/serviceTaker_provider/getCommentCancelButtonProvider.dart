import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serialno_app/model/mybooked_model.dart';
import 'package:serialno_app/services/customer_service/serviceTaker_homeScreen/get_commentCancelButtonService.dart';

class GetCommentCancelButtonProvider with ChangeNotifier {
  final GetCommentCancelButtonService _getCommentCancelButtonService =
      GetCommentCancelButtonService();

  List<MybookedModel> _bookSerialList = [];
  List<MybookedModel> get bookSerialList => _bookSerialList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> get_commentCancelButton(String date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookSerialList = await _getCommentCancelButtonService
          .getCommentCancelButton(date);
    } catch (e) {
      _errorMessage = e.toString();
      _bookSerialList = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
