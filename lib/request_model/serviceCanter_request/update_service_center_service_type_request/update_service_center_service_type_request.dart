class update_service_center_service_type_request {
  String? id;
  String? serviceCenterId;
  int? price;
  int? defaultAllocatedTime;
  String? name;
  String? companyId;

  update_service_center_service_type_request({
    this.id,
    this.name,
    this.serviceCenterId,
    this.price,
    this.defaultAllocatedTime,
    this.companyId,
  });

  factory update_service_center_service_type_request.fromJson(
    Map<String, dynamic> json,
  ) {
    return update_service_center_service_type_request(
      id: json['id'],
      name: json['name'],
      serviceCenterId: json['serviceCenterId'],
      price: json['price'],
      defaultAllocatedTime: json['defaultAllocatedTime'],
      companyId: json['companyId'],

      // Parse other fields
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serviceCenterId': serviceCenterId,
      'price': price,
      'defaultAllocatedTime': defaultAllocatedTime,
      'companyId': companyId,

      // Add other fields
    };
  }
}
