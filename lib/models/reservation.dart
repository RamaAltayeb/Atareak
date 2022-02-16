import 'dart:convert';

import 'package:atareak/controllers/datetime_controller.dart';

class Reservation {
  dynamic pickPoint;
  dynamic dropPoint;
  DateTime pickTime;
  bool approved;
  //
  String tripId;
  int seats;
  //
  String userId;
  String userName;
  String userImage;

  Reservation.fromJson(Map<String, dynamic> json) {
    pickPoint = jsonDecode(json['pickPoint']);
    dropPoint = jsonDecode(json['dropPoint']);
    pickTime = DateTimeController.toDateTime(json['pickTime']);
    seats = json['seats'];
    approved = json['approved'];
    if (json['tripId'] != null) {
      tripId = json['tripId'];
    }
    if (json['userId'] != null) {
      userId = json['userId'];
    }
    if (json['userName'] != null) {
      userName = json['userName'];
    }
    if (json['userImg'] != null) {
      userImage = json['userImg'];
    }
  }
}
