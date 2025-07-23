


import 'package:flutter/cupertino.dart';

import '../services/change_password_service.dart';

class PasswordUpdateProvider with ChangeNotifier{

final ChangePasswordService changePasswordService = ChangePasswordService();

String? _token;
String? get Token => _token;
String ? _errorMessage;
String ? get errorMessage=> _errorMessage;

bool isLoading=false;


  Future<bool>fetchUpdatePassword({
  required String currentPassword,
    required String newPassword

})async{
    isLoading = true;
    notifyListeners();
final success= await changePasswordService.UpdatePasswors(
    currentPassword: currentPassword,
    newPassword: newPassword
);

isLoading = false;
notifyListeners();
return success;
  }

}