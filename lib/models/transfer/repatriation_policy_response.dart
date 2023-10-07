class RepatriationPolicyResponse {
  int? errorCode;
  String? transferTo;
  int? debitedAmount;
  double? exRate;
  double? transferAmount;
  String? policyNo;
  String? authNo;

  RepatriationPolicyResponse(
      {this.errorCode,
      this.transferTo,
      this.debitedAmount,
      this.exRate,
      this.transferAmount,
      this.policyNo,
      this.authNo});

  RepatriationPolicyResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    transferTo = json['TransferTo'];
    debitedAmount = json['DebitedAmount'] is int
        ? (json['DebitedAmount'] as int).toDouble()
        : json['DebitedAmount'];
    exRate = json['ExRate'];
    transferAmount = json['TransferAmount'];
    policyNo = json['PolicyNo'];
    authNo = json['AuthNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['TransferTo'] = this.transferTo;
    data['DebitedAmount'] = this.debitedAmount;
    data['ExRate'] = this.exRate;
    data['TransferAmount'] = this.transferAmount;
    data['PolicyNo'] = this.policyNo;
    data['AuthNo'] = this.authNo;
    return data;
  }
}
