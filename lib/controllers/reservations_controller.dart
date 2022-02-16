import 'dart:convert';

import 'package:atareak/controllers/geo_point_controller.dart';
import 'package:atareak/controllers/network_handler.dart';
import 'package:atareak/controllers/datetime_controller.dart';
import 'package:atareak/models/reservation.dart';
import 'package:atareak/views/utilities/server_messages_translator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ReservationsController extends GetxController {
  static final NetworkHandler _networkHandler = NetworkHandler();
  static String errorMessage = '';

  Future<bool> createAReservation({
    String tripId,
    dynamic pickPoint,
    dynamic dropPoint,
    DateTime dateTime,
    int seats,
  }) async {
    final GeoPointController _geoPointController =
        Get.put(GeoPointController());
    final Map<String, dynamic> launchPoint =
        await _geoPointController.getPointJson(pickPoint);
    final Map<String, dynamic> destination =
        await _geoPointController.getPointJson(dropPoint);
    final Map<String, dynamic> data = {
      'tripId': tripId,
      'pickPoint': jsonEncode(launchPoint),
      'dropPoint': jsonEncode(destination),
      'pickTime': DateTimeController.dateTimeToString(dateTime),
      'approved': false,
      'seats': seats,
    };
    final response = await _networkHandler.post('/passenger/$tripId', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    errorMessage = serverMessageTranslator(response.body);
    return false;
  }

  Future<Reservation> getUserReservationDetails({String tripId}) async {
    final response =
        await _networkHandler.get('/passenger/$tripId/reservation');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> output = jsonDecode(response.body);
      return Reservation.fromJson(output);
    }
    errorMessage = serverMessageTranslator(response.body);
    return null;
  }

  Future<List<Reservation>> getUserReservations({int page}) async {
    final Map<String, dynamic> data = {'page': page.toString()};
    final response = await _networkHandler.get('/passenger', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> output = jsonDecode(response.body);
      final List<Reservation> reservations = [];
      for (final dynamic json in output) {
        reservations.add(Reservation.fromJson(json));
      }
      return reservations;
    }
    errorMessage = serverMessageTranslator(response.body);
    return [null];
  }

  Future<bool> deleteReservation({String tripId}) async {
    final response = await _networkHandler.delete('/passenger/$tripId');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    errorMessage = serverMessageTranslator(response.body);
    return null;
  }
}
