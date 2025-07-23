


class ServiceTypeModel{

  final String id;
  final String? name;
  num? price;
  num? defaultAllocatedTime;
  final String? companyId;
  final String? serviceCenterId;

  ServiceTypeModel({
    required this.id,
    this.name,
    this.price,
    this.defaultAllocatedTime,
    this.companyId,
    this.serviceCenterId
  });


  factory ServiceTypeModel.fromJson(Map<String,dynamic>json){
    return ServiceTypeModel(
        id: json["id"] as String,
        name: json["name"] as String?,
        price: json["price"] as num?,
        defaultAllocatedTime: json["defaultAllocatedTime"]as num?,
        companyId: json["companyId"]as String?,
      serviceCenterId: json["serviceCenterId"] as String?

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "name":name,
      "price":price,
      "defaultAllocatedTime":defaultAllocatedTime,
      "companyId":companyId,
      "serviceCenterId":serviceCenterId
    };
  }


}