import 'dart:convert';

class User {
  String id;
  String name;
  String gender;
  int phone;
  int age;
  String image;
  String description;
  bool smoker;
  double rating;
  List<dynamic> comments;

  User({
    this.id,
    this.name,
    this.gender,
    this.phone,
    this.age,
    this.image,
    this.description,
    this.smoker,
    this.rating,
    this.comments,
  });

  User.fromJson(String id, Map<String, dynamic> json) {
    // ignore: prefer_initializing_formals
    this.id = id;
    name = json['userName'];
    gender = json['gender'];
    phone = json['phone'];
    age = json['age'];
    image = json['img'];
    rating = json['rating'].toDouble();
    comments = json['comments'];
    final decodedDescription = jsonDecode(json['description']);
    description = decodedDescription['description'];
    smoker = decodedDescription['smoker'];
  }
}

class Driver {
  String id;
  String name;

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
  }
}

class Client {
  String id;
  String name;
  int seats;

  Client({this.id, this.name, this.seats});

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    seats = json['seats'];
  }
}
