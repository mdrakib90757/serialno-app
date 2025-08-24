class serviceTypeModel {
  final String id;
  final String? name;
  final double? price;
  final int? defaultAllocatedTime;
  final String? companyId;
  final String? serviceCenterId;

  serviceTypeModel({
    required this.id,
    this.name,
    this.price,
    this.defaultAllocatedTime,
    this.companyId,
    this.serviceCenterId,
  });

  factory serviceTypeModel.fromJson(Map<String, dynamic> json) {
    return serviceTypeModel(
      id: json["id"] ??"",
      name: json["name"],
      price: (json["price"] as num?)?.toDouble(),
      defaultAllocatedTime: (json["defaultAllocatedTime"] as num?)?.toInt(),
      companyId: json["companyId"] as String?,
      serviceCenterId: json["serviceCenterId"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "defaultAllocatedTime": defaultAllocatedTime,
      "companyId": companyId,
      "serviceCenterId": serviceCenterId,
    };
  }
}
