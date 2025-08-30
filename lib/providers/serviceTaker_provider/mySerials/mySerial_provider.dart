import 'package:flutter/cupertino.dart';
import '../../../api/serviceTaker_api/myserials_serviceTaker/my_serials_service.dart';
import '../../../model/myService_model.dart';

class MySerialServiceTakerProvider with ChangeNotifier {
  MySerialService _mySerialService = MySerialService();

  List<MyService> _services = [];
  List<MyService> get services => _services;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> MyServicesProvider({
    required int pageNo,
    required int pageSize,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _mySerialService.fetchMyServices(
        pageNo: pageNo,
        pageSize: pageSize,
      );
      _services.addAll(response);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
