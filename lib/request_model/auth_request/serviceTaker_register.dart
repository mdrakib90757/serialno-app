class ServiceTakerRequest {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? loginName;
  String? password;

  ServiceTakerRequest({
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.loginName,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone, // Note: lowercase 'phone' as per working example
      "gender": gender,
      "loginName": loginName,
      "password": password,
    };
  }
}
