class Car {
  String id;
  String model;
  String description;
  bool isOwner;

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    model = json['name'];
    description = json['description'];
    isOwner = json['isOwner'];
  }
}
