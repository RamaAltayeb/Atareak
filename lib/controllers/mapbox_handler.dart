import 'package:atareak/controllers/internet_connection_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'network_handler.dart';
import 'utilities/map_consts.dart';

class MapBoxHandler {
  final String _baseURLStart =
      'https://api.mapbox.com/directions/v5/mapbox/driving/';
  final String _baseURLAccessToken =
      '?alternatives=true&geometries=geojson&steps=false&access_token=$mapboxAccessToken';
  final String _baseURLDateTime = '&depart_at=';
  final _logger = Logger();
  final timeOutDuration = const Duration(seconds: 30);
  final noInternetResponse = http.Response('No Internet Connection', 500);
  final timeOutResponce = http.Response('Connection Time Out', 500);

  final InternetConnectionController _internetConnectionController =
      Get.put(InternetConnectionController());

  Future<http.Response> get(LatLng startPoint, LatLng endPoint,
      {String dateTime = ''}) async {
    if (!await _internetConnectionController.checkInternetConnection()) {
      return noInternetResponse;
    }
    final response = await http
        .get(
      _urlParser(
          '${startPoint.longitude},${startPoint.latitude};${endPoint.longitude},${endPoint.latitude}',
          dateTime),
    )
        .timeout(
      timeOutDuration,
      onTimeout: () {
        return timeOutResponce;
      },
    );

    NetworkHandler.loggerResponsePrinter(response);

    return response;
  }

  Uri _urlParser(String latLngURLPart, String dateTime) {
    dateTime = dateTime.compareTo('') != 0 ? _baseURLDateTime + dateTime : '';
    _logger.wtf(
        'Uri: ${Uri.parse(_baseURLStart + latLngURLPart + _baseURLAccessToken + dateTime)}');
    return Uri.parse(
        _baseURLStart + latLngURLPart + _baseURLAccessToken + dateTime);
  }

  Future<http.Response> getPointLocationName(LatLng latLng) async {
    if (!await _internetConnectionController.checkInternetConnection()) {
      return noInternetResponse;
    }
    final String url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${latLng.longitude.toString()}%2C${latLng.latitude.toString()}.json?access_token=$mapboxAccessToken';
    final response = await http
        .get(
      Uri.parse(url),
    )
        .timeout(
      timeOutDuration,
      onTimeout: () {
        return timeOutResponce;
      },
    );

    NetworkHandler.loggerResponsePrinter(response);

    return response;
  }

  Future<http.Response> getGeoCoding(String place) async {
    if (!await _internetConnectionController.checkInternetConnection()) {
      return noInternetResponse;
    }
    final String url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$place.json?access_token=$mapboxAccessToken&cachebuster=1621946671535&autocomplete=true&country=sy';
    final response = await http
        .get(
      Uri.parse(url),
    )
        .timeout(
      timeOutDuration,
      onTimeout: () {
        return timeOutResponce;
      },
    );

    NetworkHandler.loggerResponsePrinter(response);

    return response;
  }
}
