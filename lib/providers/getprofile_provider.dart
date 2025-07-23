



import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/profile_user_model.dart';
import '../services/profile_update_service.dart';
import 'auth_providers.dart';

class Getprofileprovider with ChangeNotifier{

  String ? _token;
  String? get token => _token;

  profile_UserModel? _profileData;
  profile_UserModel? get profileData => _profileData;

  profile_UserModel? _profile_userModel;
  profile_UserModel? get profile_userModel => _profile_userModel;

  //get token
  Future<void>getToken()async{
    final prefs= await SharedPreferences.getInstance();
    final token = await AuthProvider().getToken();
     _token=prefs.getString("accessToken");

  }


  //get method provider
  Future<void> fetchUserProfile( ) async {
    await getToken();
    if(_token != null){
      _profileData = await GetProfileServices().getupdateProfile(_token!);
      notifyListeners();
    }else{
      debugPrint("❌ Token is null. Can't fetch profile.");
    }



  }
  void clearProfile() {
  _profileData=null;
  _token=null;
    notifyListeners();
    print("Getprofileprovider cleared!");
  }

}