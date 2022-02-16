import 'dart:convert';

import 'package:atareak/controllers/datetime_controller.dart';
import 'package:atareak/controllers/geo_point_controller.dart';
import 'package:atareak/models/map_route.dart';
import 'package:atareak/models/reservation.dart';
import 'package:atareak/models/trip.dart';
import 'package:atareak/views/utilities/server_messages_translator.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'network_handler.dart';

class TripsController extends GetxController {
  static final NetworkHandler _networkHandler = NetworkHandler();
  static String errorMessage = '';

  Future<bool> createATrip({
    dynamic carId,
    dynamic seats,
    dynamic price,
    MapRoute route,
  }) async {
    final Map<String, dynamic> json = route.json;
    json.addAll({'status': route.status});

    final duration = json['duration'];

    final arrivalTime =
        route.launchTime.add(Duration(seconds: duration.toInt()));

    final GeoPointController _geoPointController =
        Get.put(GeoPointController());
    if (route.launchPoint['name'].isEmpty) {
      route.launchPoint = await _geoPointController.getPointJson(LatLng(
          route.launchPoint['location'].last,
          route.launchPoint['location'].first));
    }
    if (route.destination['name'].isEmpty) {
      route.destination = await _geoPointController.getPointJson(LatLng(
          route.destination['location'].last,
          route.destination['location'].first));
    }

    final Map<String, dynamic> data = {
      'lunchPoint': jsonEncode(route.launchPoint),
      'destination': jsonEncode(route.destination),
      'distance': json['distance'],
      'lunchTime': DateTimeController.dateTimeToString(route.launchTime),
      'estimatedTime': DateTimeController.dateTimeToString(arrivalTime),
      'car': carId.toString(),
      'seats': seats,
      'price': price,
      'throughPath': jsonEncode(json),
    };
    final response = await _networkHandler.post('/trip', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    errorMessage = serverMessageTranslator(response.body);
    return false;
  }

  Future<Trip> getTripDetails({String id}) async {
    final response = await _networkHandler.get('/passenger/$id');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> output = jsonDecode(response.body);
      return Trip.fromJson(output);
    }
    errorMessage = serverMessageTranslator(response.body);
    return null;
  }

  Future<List<Trip>> getUserTrips({int page}) async {
    final Map<String, dynamic> data = {'page': page.toString()};
    final response = await _networkHandler.get('/trip', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> output = jsonDecode(response.body);
      final List<Trip> trips = [];
      for (final dynamic json in output) {
        trips.add(await getTripDetails(id: json['id']));
      }
      return trips;
    }
    errorMessage = serverMessageTranslator(response.body);
    return [null];
  }

  Future<bool> deleteTrip({String id}) async {
    final response = await _networkHandler.delete('/trip/$id');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body); // returns bool
    }
    errorMessage = serverMessageTranslator(response.body);
    return null;
  }

  Future<List<Trip>> searchTrips({
    LatLng launchPoint,
    LatLng destination,
    DateTime dateTime,
    String radios,
  }) async {
    final Map<String, dynamic> data = {
      'StartLon': launchPoint.longitude.toString(),
      'StartLat': launchPoint.latitude.toString(),
      'EndLon': destination.longitude.toString(),
      'EndLat': destination.latitude.toString(),
      'AtTime': DateTimeController.dateTimeToString(dateTime),
    };
    data.addIf(radios.isNotEmpty, 'Distance', radios);
    final response = await _networkHandler.get('/passenger/suggest', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> output = jsonDecode(response.body);
      final List<Trip> trips = [];
      for (final dynamic json in output) {
        trips.add(await getTripDetails(id: json['id']));
      }
      return trips;
    }
    errorMessage = serverMessageTranslator(response.body);
    return null;
  }

  Future<List<Reservation>> getTripReservationRequests({String id}) async {
    final response = await _networkHandler.get('/trip/$id');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> output = jsonDecode(response.body);
      final List<Reservation> reservations = [];
      for (final dynamic json in output) {
        reservations.add(Reservation.fromJson(json));
      }
      return reservations;
    }
    errorMessage = serverMessageTranslator(response.body);
    return null;
  }

  Future<bool> approveReservation({String tripId, String clientId}) async {
    final response =
        await _networkHandler.post('/trip/$tripId/approve/$clientId');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    errorMessage = serverMessageTranslator(response.body);
    return false;
  }
}
