class BillPaymentResponse {
  int? accountNo;
  String? authNo;
  String? billerName;
  int? errorCode;
  int? fee;
  double? productCost;
  double? totalPaid;

  BillPaymentResponse(
      {this.accountNo,
      this.authNo,
      this.billerName,
      this.errorCode,
      this.fee,
      this.productCost,
      this.totalPaid});

  BillPaymentResponse.fromJson(Map<String, dynamic> json) {
    this.authNo = json["AuthNo"];
    this.accountNo = json["AccountNo"];
    this.billerName = json["BillerName"];
    this.errorCode = json["ErrorCode"];
    this.fee = json["Fee"];
    this.productCost = json["ProductCost"];
    this.totalPaid = json["TotalPaid"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["AccountNo"] = this.accountNo;
    data["AuthNo"] = this.authNo;
    data["BillerName"] = this.billerName;
    data["ErrorCode"] = this.errorCode;
    data["Fee"] = this.fee;
    data["ProductCost"] = this.errorCode;
    data["TotalPaid"] = this.totalPaid;

    return data;
  }
}
