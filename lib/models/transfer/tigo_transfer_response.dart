class TigoTransferResponse {
  int? errorCode;
  String? transferTo;
  double? debitedAmount;
  double? exRate;
  double? transferAmount;
  String? autNo;

  TigoTransferResponse(
      {this.errorCode,
      this.transferTo,
      this.debitedAmount,
      this.exRate,
      this.transferAmount,
      this.autNo});

  TigoTransferResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    transferTo = json['TransferTo'];
    debitedAmount = json['DebitedAmount'] is int
        ? (json['DebitedAmount'] as int).toDouble()
        : json['DebitedAmount'];
    exRate = json['ExRate'];
    transferAmount = json['TransferAmount'];
    autNo = json['AuthNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['TransferTo'] = this.transferTo;
    data['DebitedAmount'] = this.debitedAmount;
    data['ExRate'] = this.exRate;
    data['TransferAmount'] = this.transferAmount;
    data['AuthNo'] = this.autNo;
    return data;
  }
}
