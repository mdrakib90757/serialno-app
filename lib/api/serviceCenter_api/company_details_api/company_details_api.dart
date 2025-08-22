import 'package:serialno_app/core/api_client.dart';
import 'package:serialno_app/model/company_details_model.dart';

class CompanyDetailsApi {
  Future<CompanyDetailsModel> companyInfo(String companyId) async {
    try {
      var response = await ApiClient().get("/companies/$companyId");
      return CompanyDetailsModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print("Error fetching or parsing companyInfo - : $e");
      throw Exception('Failed to load company details');
    }
  }
}
