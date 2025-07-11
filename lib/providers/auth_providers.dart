import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:serial_managementapp_project/model/user_model.dart';
import 'package:serial_managementapp_project/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider with ChangeNotifier{
  final AuthService authService =AuthService();
  User_Model? _userModel;
  ServiceTaker? _serviceTaker;

  User_Model? get user_model => _userModel;
  ServiceTaker? get serviceTaker => _serviceTaker;

  String?_userType;
  String? get userType =>_userType;

  bool _isLoding = false;
  bool get isLoading => _isLoding;

  String ? _errorMessage;
  String ? get errorMessage=> _errorMessage;

  String? _accessToken;
  String? get accessToken=>_accessToken;

  String? _refreshToken;
  String? get refreshToken => _refreshToken;

  String? get token => _userModel?.token; //

  void setUserModel(User_Model model) {
    _userModel = model;
    notifyListeners();
  }


  //Save Token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  //Remove  Token
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  //

  ProfileData? get userProfileData {
    return _userModel?.user.profileData;
  }





//login
  Future<void>login({
    required String loginName,
    required String password,
    required BuildContext context

  })async{
    _isLoding=true;
    _errorMessage=null;
    notifyListeners();
    try{
      final response= await authService.login(
          loginName:loginName,
          password:password
      );

      print('Full Response: $response');
      if (response["data"] == null || response["data"]["accessToken"] == null) {
        throw Exception("Invalid response: Missing access token.");
      }

      _accessToken = response["data"]["accessToken"];
      _refreshToken = response["data"]["refreshToken"];


      await saveToken(_accessToken!);
      await loadUserFromToken();


      if (response["data"]["serviceTaker"] != null) {
        _serviceTaker = ServiceTaker.fromJson(response["data"]["serviceTaker"]);
        //print("ServiceTaker loaded: ${serviceTaker?.gender}");
      }


      //JWT token decode usertype
      _userType= JwtDecoder.decode(_accessToken!)["userType"]?.toString().trim();;

     ///user_model=User_Model.fromJson(response["data"]);

     notifyListeners();

    }catch(e){
      _errorMessage = e.toString().replaceAll("Exception: ", "").trim();
      print("$e");
      notifyListeners();

    }finally{
      _isLoding=false;
      notifyListeners();
    }
  }

  void clearError(){
    _errorMessage= null;
    notifyListeners();
  }

  void setUser(User_Model userModel, String token) {
    _userModel = userModel;
    _accessToken = token;
    notifyListeners();
  }



// Load user from saved token
  Future<void> loadUserFromToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');



    if (token != null) {
      _accessToken = token;

      Map<String, dynamic> decodedToken = JwtDecoder.decode(_accessToken!);
      print("Decoded Token From Saved Token: $decodedToken");
      _userType = decodedToken["userType"]?.toString().trim();
     // final profileDataJsonString = decodedToken["profileData"];
      ProfileData? profileObj;
      try {
        final profileRaw = decodedToken["profileData"]; // ছোট অক্ষরে
        if (profileRaw != null) {
          if (profileRaw is String) {
            final decodedProfile = jsonDecode(profileRaw);
            profileObj = ProfileData.fromJson(decodedProfile);
          } else if (profileRaw is Map<String, dynamic>) {
            profileObj = ProfileData.fromJson(profileRaw);
          }
        }
      } catch (e) {
        print("Error decoding profileData: $e");
      }


      _userModel = User_Model(
        company: Company(
          id: "",
          name: "Default Company",
          addressLine1: "",
          addressLine2: "",
          email: decodedToken["email"] ?? "",
          phone: decodedToken["mobileNo"] ?? "",
          createDate: "",
          isActive: true,
        ),
        user: User(
          id: decodedToken["userId"] ?? "",
          name: decodedToken["name"] ?? "",
          email: decodedToken["email"] ?? "",
          mobileNo: decodedToken["mobileNo"] ?? "",
          loginName: decodedToken["loginName"] ?? "",
          registeredDate: "",
          isActive: true,
          userType: decodedToken["userType"] ?? "",
          profileData: profileObj,
        ),
        serviceCenter: ServiceCenter(
          id: "",
          name: "",
          email: "",
          hotlineNo: "",
          companyId: "",
        ), token: '',
      );

      if (_userType?.toLowerCase() == "customer") {
        try {
          final profileData = userProfileData;
          if (profileData != null) {
            _serviceTaker = ServiceTaker(
              id: _userModel!.user.id,
              name: _userModel!.user.name,
              email: _userModel!.user.email,
              phone: _userModel!.user.mobileNo,
              loginName: _userModel!.user.loginName,
              password: "",
              registeredDate: "",
              isActive: true,
              userType: decodedToken["userType"] ?? "",
              profileData: profileObj,
            );
          }
        } catch (e) {
          print("Error creating ServiceTaker: $e");
        }
      }

      notifyListeners();
      print("User loaded from token successfully");
    } else {
      print("No token found in SharedPreferences.");
    }
  }


  //LogOut Method
  Future<void>LogOut()async{
    final prefs= await SharedPreferences.getInstance();
    await prefs.clear();
  _accessToken=null;
  _refreshToken =null;
  _userType=null;;
  _userModel=null;
  _errorMessage=null;
  _isLoding=false;
  notifyListeners();
  }


//service_center register
  Future<Map<String, dynamic>?>register({required String name,
    required String addressLine1,
    required String addressLine2,
    required String contactName,
    required String email,
    required String phone,
    required String organizationName,
    required int businessTypeId,
    required String loginName,
    required String password,
  })async{
    _isLoding = true;
    notifyListeners();

    final result = await authService.registerServiceCenter(
      name: name,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      contactName: contactName,
      email: email,
      phone: phone,
      organizationName: organizationName,
      businessTypeId: businessTypeId,
      loginName: loginName,
      password: password,
    );

    if(result?["success"]==true){
      _userModel=result?["data"];

      // final data = {
      //   // ... অন্যান্য ডাটা
      //   'businessTypeId': businessTypeId,
      //   // organization শুধুমাত্র medical এর জন্য
      //   if(businessTypeId == 1) 'organizationName': organizationName,
      // };

    }
    _isLoding=false;
    notifyListeners();
    return  result;
  }


//service_taker register
  Future<Map<String,dynamic>?>serviceTakerRegister({
     String? id,
    required String name,
    required String email,
    required String phone,  // Changed from mobileNo
    required String loginName,
    required String password,  // Added
    required String gender,
})async {
    _isLoding = true;
    notifyListeners();

    try {
      final result = await authService.ServiceTakerRegister(
        id: id,
        name: name,
        email: email,
        phone: phone.trim(),
        loginName: loginName,
        password: password,
        gender: gender,

      );
      if (result?["success"] == true) {
        if (result?["data"] != null) {
          return {
            'success': true,
            'data': result?['data'], // Keep as Map if model conversion fails
            'message': 'Registration successful'
          };
        } else {
          return {
            'success': false,
            'message': 'Registration incomplete - missing data'
          };
        }
        return result;
      }
      _isLoding = false;
      notifyListeners();
      return result;

    } catch (e) {
      _isLoding = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Registration failed: ${e.toString()}'
      };
    }
  }



  Future<void> updateUserProfile({
    required String newName,
    required String newEmail,
    required String newMobileNo,
    required ProfileData? newProfileData,
  }) async {
    if (user_model != null) {
      final updatedUser = user_model!.user.copyWith(
        name: newName,
        email: newEmail,
        mobileNo: newMobileNo,
        profileData: newProfileData,
      );

      _userModel = User_Model(
        company: user_model!.company,
        user: updatedUser,
        serviceCenter: user_model!.serviceCenter,
        token: accessToken, // যদি থাকে
      );

      notifyListeners();

      print("AuthProvider user model updated successfully!");
    }
  }




}

