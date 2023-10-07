class CustomerVerifyResponse {
  int? errorCode;
  int? cHolderID;
  String? holder;
  int? cardNo;
  int? phoneNo;

  CustomerVerifyResponse(
      {this.errorCode, this.cHolderID, this.holder, this.cardNo, this.phoneNo});

  CustomerVerifyResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    cHolderID = json['CHolderID'];
    holder = json['Holder'];
    cardNo = json['CardNo'];
    phoneNo = json['PhoneNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['CHolderID'] = this.cHolderID;
    data['Holder'] = this.holder;
    data['CardNo'] = this.cardNo;
    data['PhoneNo'] = this.phoneNo;
    return data;
  }
}
