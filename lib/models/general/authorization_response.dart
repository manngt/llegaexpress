class AuthorizationResponse {
  String? authNo;
  int? errorCode;

  AuthorizationResponse({this.authNo, this.errorCode});

  AuthorizationResponse.fromJson(Map<String, dynamic> json) {
    authNo = json["AuthNo"];
    errorCode = json["ErrorCode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ErrorCode"] = this.errorCode;
    data["AuthNo"] = this.authNo;

    return data;
  }
}
