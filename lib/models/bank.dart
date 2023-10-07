class Bank {
  String? bankId;
  String? bankName;
  String? countryId;

  Bank({this.bankId, this.bankName, this.countryId});

  Bank.fromJson(Map<String, dynamic> json) {
    this.bankId = json["BankID"];
    this.bankName = json["BankName"];
    this.countryId = json["CountryID"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["CountryID"] = this.countryId;
    data["BankID"] = this.bankId;
    data["BankName"] = this.bankName;
    return data;
  }
}
