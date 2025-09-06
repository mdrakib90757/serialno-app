import 'package:flutter/material.dart';
import 'package:serialno_app/api/serviceCenter_api/location_api_service_center/location_api_service_center.dart';
import 'package:serialno_app/model/company_details_model.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();

  List<LocationPart> divisions = [];
  List<LocationPart> districts = [];
  List<LocationPart> thanas = [];
  List<LocationPart> areas = [];

  bool isLoading = false;

  Future<void> getDivisions() async {
    isLoading = true;
    notifyListeners();
    try {
      divisions = await _locationService.fetchDivisions();
    } catch (e) {
      print("Error in getDivisions Provider: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDistricts(int divisionId) async {
    isLoading = true;
    districts = [];
    notifyListeners();
    try {
      districts = await _locationService.fetchDistricts(divisionId);
    } catch (e) {
      print("Error in getDistricts Provider: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getThanas(int districtId) async {
    isLoading = true;
    thanas = [];
    notifyListeners();
    try {
      thanas = await _locationService.fetchThanas(districtId);
    } catch (e) {
      print("Error in getThanas Provider: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAreas(int thanaId) async {
    isLoading = true;
    areas = [];
    notifyListeners();
    try {
      areas = await _locationService.fetchAreas(thanaId);
    } catch (e) {
      print("Error in getAreas Provider: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearDistricts() {
    districts = [];
    notifyListeners();
  }

  void clearThanas() {
    thanas = [];
    notifyListeners();
  }

  void clearAreas() {
    areas = [];
    notifyListeners();
  }
}
