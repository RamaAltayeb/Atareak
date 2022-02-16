import 'dart:convert';

import 'package:atareak/controllers/mapbox_handler.dart';
import 'package:atareak/views/utilities/server_messages_translator.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class GeoPointController extends GetxController {
  static String errorMessage = '';

  Future<dynamic> getPointLocationName(LatLng latlng) async {
    final MapBoxHandler _mapBoxHandler = MapBoxHandler();
    final response = await _mapBoxHandler.getPointLocationName(latlng);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> output = jsonDecode(response.body);
      return output['features'][0]['text'];
    }
    errorMessage = serverMessageTranslator(response.body);
    return null;
  }

  Map<String, dynamic> pointToJson(LatLng latlng, String name) {
    final Map<String, dynamic> data = {
      'name': name,
      'location': [latlng.longitude, latlng.latitude]
    };
    return data;
  }

  Future<Map<String, dynamic>> getPointJson(LatLng latlng) async {
    final String name = await getPointLocationName(latlng);
    if (name != null) {
      return pointToJson(latlng, name);
    }
    return {};
  }
}
