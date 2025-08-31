import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../api/serviceTaker_api/myserials_serviceTaker/my_serials_service.dart';
import '../../../model/myService_model.dart';

class MySerialServiceTakerProvider with ChangeNotifier {
  final MySerialService _mySerialService = MySerialService();

  Map<String, List<MyService>> _groupedServices = {};
  Map<String, List<MyService>> get groupedServices => _groupedServices;

  List<String> _sortedDates = [];
  List<String> get sortedDates => _sortedDates;

  List<MyService> _allServices = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  final int _pageSize = 10;

  Future<void> fetchMyServices({bool isRefresh = false}) async {
    if (_isLoading || (!_hasMore && !isRefresh)) return;

    if (isRefresh) {
      _currentPage = 1;
      _allServices = [];
      _hasMore = true;
      _isLoading = true;
      notifyListeners();
    }

    try {
      final newServices = await _mySerialService.fetchMyServices(
        pageNo: _currentPage,
        pageSize: _pageSize,
      );

      if (newServices.length < _pageSize) {
        _hasMore = false;
      }

      _allServices.addAll(newServices);
      _currentPage++;

      _groupData();
      // ---------------------------------
    } catch (e) {
      // Handle error
    } finally {
      if (isRefresh) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  void _groupData() {
    _groupedServices = groupBy(_allServices, (MyService service) {
      if (service.date == null) return 'Unknown Date';
      return DateFormat('yyyy/MM/dd').format(service.date!);
    });

    _sortedDates = _groupedServices.keys.toList()
      ..sort((a, b) => b.compareTo(a));
  }
}
