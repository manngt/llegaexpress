class DocumentType {
  String? description;
  String? ID;

  DocumentType({this.description, this.ID});

  DocumentType.fromJson(Map<String, dynamic> json) {
    description = json["Description"];
    ID = json["ID"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["ID"] = this.ID;
    data["Description"] = this.description;

    return data;
  }
}
