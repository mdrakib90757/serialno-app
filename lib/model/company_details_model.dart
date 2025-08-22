class CompanyDetailsModel {
  BusinessType? businessType;
  Division? division;
  District? district;
  District? thana;
  Null? area;
  String? id;
  String? name;
  String? addressLine1;
  String? addressLine2;
  String? email;
  String? phone;
  String? createDate;
  bool? isActive;
  int? businessTypeId;
  Null? location;
  int? divisionId;
  int? districtId;
  int? thanaId;
  Null? areaId;
  Null? logo;

  CompanyDetailsModel(
      {this.businessType,
        this.division,
        this.district,
        this.thana,
        this.area,
        this.id,
        this.name,
        this.addressLine1,
        this.addressLine2,
        this.email,
        this.phone,
        this.createDate,
        this.isActive,
        this.businessTypeId,
        this.location,
        this.divisionId,
        this.districtId,
        this.thanaId,
        this.areaId,
        this.logo});

  CompanyDetailsModel.fromJson(Map<String, dynamic> json) {
    businessType = json['businessType'] != null
        ? new BusinessType.fromJson(json['businessType'])
        : null;
    division = json['division'] != null
        ? new Division.fromJson(json['division'])
        : null;
    district = json['district'] != null
        ? new District.fromJson(json['district'])
        : null;
    thana = json['thana'] != null ? new District.fromJson(json['thana']) : null;
    area = json['area'];
    id = json['id'];
    name = json['name'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    email = json['email'];
    phone = json['phone'];
    createDate = json['createDate'];
    isActive = json['isActive'];
    businessTypeId = json['businessTypeId'];
    location = json['location'];
    divisionId = json['divisionId'];
    districtId = json['districtId'];
    thanaId = json['thanaId'];
    areaId = json['areaId'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.businessType != null) {
      data['businessType'] = this.businessType!.toJson();
    }
    if (this.division != null) {
      data['division'] = this.division!.toJson();
    }
    if (this.district != null) {
      data['district'] = this.district!.toJson();
    }
    if (this.thana != null) {
      data['thana'] = this.thana!.toJson();
    }
    data['area'] = this.area;
    data['id'] = this.id;
    data['name'] = this.name;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['createDate'] = this.createDate;
    data['isActive'] = this.isActive;
    data['businessTypeId'] = this.businessTypeId;
    data['location'] = this.location;
    data['divisionId'] = this.divisionId;
    data['districtId'] = this.districtId;
    data['thanaId'] = this.thanaId;
    data['areaId'] = this.areaId;
    data['logo'] = this.logo;
    return data;
  }
}

class BusinessType {
  int? id;
  String? name;
  Null? config;

  BusinessType({this.id, this.name, this.config});

  BusinessType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    config = json['config'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['config'] = this.config;
    return data;
  }
}

class Division {
  int? id;
  String? name;
  String? type;
  Null? parentId;

  Division({this.id, this.name, this.type, this.parentId});

  Division.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    parentId = json['parentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['parentId'] = this.parentId;
    return data;
  }
}

class District {
  int? id;
  String? name;
  String? type;
  int? parentId;

  District({this.id, this.name, this.type, this.parentId});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    parentId = json['parentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['parentId'] = this.parentId;
    return data;
  }
}