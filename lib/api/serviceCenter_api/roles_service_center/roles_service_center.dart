

import 'package:serialno_app/core/api_client.dart';
import 'package:serialno_app/model/roles_model.dart';

class RolesApi{

  Future<RolesModel> RolesInfo() async {
    try {
      var response = await ApiClient().get("/roles");
      return RolesModel.fromJson(response as Map<String, dynamic>);
    }catch(e){
      print("Error fetching or parsing RolesInfo  - : $e");
      throw Exception('Failed to load company details');
    }
  }
}