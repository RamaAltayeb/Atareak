import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:atareak/controllers/network_handler.dart';
import 'package:atareak/models/car.dart';
import 'package:atareak/controllers/utilities/pref_keys.dart';
import 'package:atareak/views/utilities/server_messages_translator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarsController extends GetxController {
  static final NetworkHandler _networkHandler = NetworkHandler();
  static String errorMessage = '';

  Future<http.Response> doesUserHaveCars() async {
    final response = await _networkHandler.get('/car');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> output = jsonDecode(response.body);
      if (output.isEmpty) {
        prefs.setBool(PrefKeys.userHasCars, false);
      } else {
        prefs.setBool(PrefKeys.userHasCars, true);
      }
    } else {
      errorMessage = serverMessageTranslator(response.body);
      prefs.setBool(PrefKeys.userHasCars, false);
    }
    return response;
  }

  Future<List<Car>> getUserCars() async {
    final response = await doesUserHaveCars();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> output = jsonDecode(response.body);
      final List<Car> cars = [];
      for (final dynamic carJson in output) {
        final Car car = Car.fromJson(carJson);
        cars.add(car);
      }
      return cars;
    }
    return [null];
  }

  Future<bool> createACarSharingRequest({String id}) async {
    final Map<String, dynamic> data = {'CarId': id};
    final response = await _networkHandler.post('/car/$id', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body == 'false') {
        errorMessage = serverMessageTranslator(response.body);
        return false;
      }
      return true;
    }
    errorMessage = serverMessageTranslator(response.body);
    return null;
  }

  Future<bool> acceptACarSharingRequest({String carId, String clientId}) async {
    final Map<String, dynamic> data = {
      'userId': clientId,
      'carId': carId,
    };
    final response = await _networkHandler.post('/car/approve', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body == 'false') {
        errorMessage = serverMessageTranslator(response.body);
        return false;
      }
      return true;
    }
    errorMessage = serverMessageTranslator(response.body);
    return null;
  }
}
