class Country {
  String? alpha3;
  String? countryCode;
  String? name;

  Country({this.alpha3, this.countryCode, this.name});

  Country.fromJson(Map<String, dynamic> json) {
    alpha3 = json["alpha-3"];
    countryCode = json["country-code"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["alpha-3"] = this.alpha3;
    data["country-code"] = this.countryCode;
    data["name"] = this.name;

    return data;
  }
}
