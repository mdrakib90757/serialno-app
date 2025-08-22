class NewSerialButtonRequest {
  String? serviceCenterId;
  String? serviceTypeId;
  String? serviceDate;
  String? name;
  String? contactNo;
  String? serviceCenterName;
  bool? forSelf = false;

  NewSerialButtonRequest({
    this.name,
    this.serviceCenterId,
    this.serviceTypeId,
    this.serviceDate,
    this.contactNo,
    this.forSelf,
    this.serviceCenterName,
  });

  Map<String, dynamic> toJson() {
    return {
      "serviceTypeId": serviceTypeId,
      "serviceDate":
          serviceDate, // ISO 8601 format (e.g., "2025-07-21T17:40:14.462Z")
      "name": name,
      "contactNo": contactNo,
      "forSelf": forSelf,
    };
  }
}
