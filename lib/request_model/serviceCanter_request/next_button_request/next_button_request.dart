// lib/request_model/next_button_request.dart

class NextButtonRequest {
  String? date;

  NextButtonRequest({this.date});

  Map<String, dynamic> toJson() {
    return {"date": date};
  }
}
