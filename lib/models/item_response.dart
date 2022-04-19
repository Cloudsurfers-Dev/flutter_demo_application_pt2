class ItemResponse {
  int? id;
  String? name;
  String? description;

  ItemResponse({
    this.id,
    this.name,
    this.description,
  });

  ItemResponse.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
  }
}
