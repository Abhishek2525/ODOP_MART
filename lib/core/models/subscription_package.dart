class SubscriptionPackage {
  int id;
  String name;
  int price;
  String duration;
  String descriptions;
  String createdAt;
  String updatedAt;

  SubscriptionPackage(
      {this.id,
      this.name,
      this.price,
      this.duration,
      this.descriptions,
      this.createdAt,
      this.updatedAt});

  SubscriptionPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    duration = json['duration'];
    descriptions = json['descriptions'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['duration'] = this.duration;
    data['descriptions'] = this.descriptions;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
