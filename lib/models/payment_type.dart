class PaymentType {
  String? type;
  String? typeId;

  PaymentType({this.type, this.typeId});

  PaymentType.fromJson(Map<String, dynamic> json) {
    this.type = json["Type"];
    this.typeId = json["TypeID"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["TypeID"] = this.typeId;
    data["Type"] = this.type;

    return data;
  }
}
