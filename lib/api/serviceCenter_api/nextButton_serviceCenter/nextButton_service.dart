import 'package:serialno_app/core/api_client.dart';
import 'package:serialno_app/model/serialService_model.dart';

class NextButtonService {
  Future<dynamic> nextButton({
    required String serviceCenterId,
    required String date,
  }) async {
    try {
      var response = await ApiClient().post(
        "/serial-no/service-centers/$serviceCenterId/services/$date/next",
      );

      return response;
    } catch (e) {
      print("Error triggering next action: $e");
      throw Exception("Failed to trigger next action: $e");
    }
  }

  Future<List<SerialModel>> getNextButton(
    String serviceCenterId,
    String date,
  ) async {
    try {
      final Map<String, String> queryParameters = {'date': date};
      var response =
          await ApiClient().get(
                "/serial-no/service-centers/$serviceCenterId/services",
                queryParameters: queryParameters,
              )
              as List;
      List<SerialModel> NewButtonData = response
          .map((data) => SerialModel.fromJson(data))
          .toList();
      return NewButtonData;
    } catch (e) {
      print("Error fetching or parsing NewButtonData - : $e");
      return [];
    }
  }
}
