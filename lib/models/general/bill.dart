class Bill {
  int? accountNo;
  double? amount;
  int? billerId;
  String? billerName;
  int? invoiceNo;

  Bill(
      {this.accountNo,
      this.amount,
      this.billerId,
      this.billerName,
      this.invoiceNo});

  Bill.fromJson(Map<String, dynamic> json) {
    this.accountNo = json["AcoountNo"];
    this.amount = json["Amount"];
    this.billerId = json["BillerID"];
    this.billerName = json["BillerName"];
    this.invoiceNo = json["InvoiceNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["AcoountNo"] = this.accountNo;
    data["Amount"] = this.amount;
    data["BillerID"] = this.billerId;
    data["BillerName"] = this.billerName;
    data["InvoiceNo"] = this.invoiceNo;

    return data;
  }
}
