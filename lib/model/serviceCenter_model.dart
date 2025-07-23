

import 'package:serial_no_app/model/profile_user_model.dart';

class ServiceCenterModel{

  final String id;
  final String? name;
  final String? hotlineNo;
  final String? email;
  final String? companyId;

  ServiceCenterModel({
     required this.id,
    this.name,
    this.hotlineNo,
    this.email,
    this.companyId
});


  factory ServiceCenterModel.fromJson(Map<String,dynamic>json){
    return ServiceCenterModel(
      id: json["id"],
      name: json["name"],
      hotlineNo: json["hotlineNo"],
      email: json["email"],
      companyId: json["companyId"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "name":name,
      "hotlineNo":hotlineNo,
      "email":email,
      "companyId":companyId
    };
  }


}