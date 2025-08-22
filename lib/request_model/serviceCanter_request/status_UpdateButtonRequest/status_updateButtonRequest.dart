class StatusButtonRequest {
  bool? isPresent;
  String? status;
  String? comment;
  String? serviceCenterId;
  String? serviceId;
  StatusButtonRequest({
    this.isPresent,
    this.status,
    this.comment,
    this.serviceCenterId,
    this.serviceId,
  });

  Map<String, dynamic> toJson() {
    return {"isPresent": isPresent, "status": status, "comment": comment};
  }
}
