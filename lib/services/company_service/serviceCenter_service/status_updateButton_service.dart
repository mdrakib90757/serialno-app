//
//
// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../utils/config/api.dart';
// import 'package:http/http.dart' as http;
//
// class StatusUpdateButton{
//
//   Future<bool>statusUpdateButton_service({
//     required bool  isPresent,
//     required String  status,
//    required  String  comment,
//     required String serviceCenterId,
//     required String serviceId,
// })async{
//
//     final prefs=await SharedPreferences.getInstance();
//     final token=prefs.getString("accessToken");
//     print("Status_UpdateButton :- ${token}");
//
//     final url = Uri.parse(
//         '${apiConfig.baseUrl}/service-centers/$serviceCenterId/services/$serviceId'
//     );
//
//
//     debugPrint("📡 StatusUpdateButton: $url");
//     print("serviceCenterId - ${serviceCenterId}");
//     print("serviceTypeId - ${serviceId}");
//
//     try{
//       final response= await http.put(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           "Authorization": "Bearer $token"
//         },
//
//         body: jsonEncode({
//
//         "isPresent":isPresent,
//           "status":status,
//           "comment":comment,
//
//
//       })
//       );
//
//       print("StatusUpdateButton ${
//           jsonEncode({
//             "isPresent":isPresent,
//             "status":status,
//             "comment":comment,
//           })
//       }");
//
//       if(response.statusCode==200 || response.statusCode==204){
//         debugPrint("✅ StatusUpdateButton Success: ${response.body}");
//         return true;
//       }else{
//         debugPrint("❌  StatusUpdateButton Failed: ${response.statusCode}");
//         debugPrint("❗ Body: ${response.body}");
//         return false;
//       }
//
//     }catch(e){
//       print('Error during StatusUpdateButton request: $e');
//       return false;
//     }
//
//   }
//
// }