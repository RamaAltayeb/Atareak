import 'dart:convert';

import 'package:atareak/controllers/datetime_controller.dart';
import 'package:atareak/models/map_route.dart';
import 'package:atareak/models/user.dart';

import 'car.dart';

class Trip {
  String id;
  dynamic launchPoint;
  dynamic destination;
  double distance;
  DateTime launchTime;
  DateTime arrivalTime;
  double duration;
  int totalSeats;
  int availableSeats;
  double totalPrice;
  double seatPrice;
  MapRoute route;
  Car car;
  Driver driver;
  List<Client> users;

  Trip.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> throughPath =
        jsonDecode(json['trip']['throughPath']);
    driver = Driver.fromJson(json['driver']);
    car = Car.fromJson(json['car']);
    id = json['trip']['id'];
    launchPoint = jsonDecode(json['trip']['lunchPoint']);
    destination = jsonDecode(json['trip']['destination']);
    distance = throughPath['distance'];
    launchTime = DateTimeController.toDateTime(json['trip']['lunchTime']);
    arrivalTime = DateTimeController.toDateTime(json['trip']['estimatedTime']);
    duration = throughPath['duration'];
    totalSeats = json['trip']['seats'];
    totalPrice = json['trip']['price'].toDouble();
    route = MapRoute(
      status: throughPath['status'],
      launchPoint: jsonDecode(json['trip']['lunchPoint']),
      destination: jsonDecode(json['trip']['destination']),
      json: throughPath,
    );
    seatPrice = double.parse((totalPrice / totalSeats).toStringAsFixed(2));
    users = [];
    int takenSeats = 0;
    for (final dynamic userJson in json['users']) {
      final Client client = Client.fromJson(userJson);
      users.add(client);
      takenSeats += client.seats;
    }
    availableSeats = totalSeats - takenSeats;
  }
}
