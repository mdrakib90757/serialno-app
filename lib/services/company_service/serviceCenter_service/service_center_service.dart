//
//
//
// import 'dart:convert';
// import 'dart:ui';
// import 'package:http/http.dart' as http;
// import 'package:serial_no_app/model/serviceCenter_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// class ServiceCenterService{
//
// Future<List<ServiceCenterModel>>ServiceCenter()async{
//   final Prefs=await SharedPreferences.getInstance();
//   final token = await Prefs.getString("accessToken");
//
//   final String baseUril ="https://serialno-api.somee.com/api/serial-no/companies/e02c600a-44ce-4748-9bad-e65aa1ce7581/service-centers";
//
//   print(" accessToken- ${token}");
//   print("baseUrl ${baseUril}");
//
//   try{
//     final respose= await http.get(Uri.parse(baseUril),
//     headers: {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer ${token}',
//     }
//     );
//     print(respose.body);
//     print(respose.statusCode);
//
//     if(respose.statusCode == 200){
//       final List<dynamic> jsonList = jsonDecode(respose.body);
//       return jsonList.map((json)=>ServiceCenterModel.fromJson(json)).toList();
//     }else{
//       print("error ${respose.body}${respose.statusCode}");
//       return [];
//     }
//
//   }catch(e){
//     print("Exception ${e}");
//     return [];
//   }
//
// }
// //
// }