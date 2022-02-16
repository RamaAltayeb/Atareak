import 'dart:convert';

import 'package:atareak/controllers/network_handler.dart';
import 'package:atareak/controllers/datetime_controller.dart';
import 'package:atareak/models/map_route.dart';
import 'package:atareak/views/utilities/server_messages_translator.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'mapbox_handler.dart';

class MapRoutesController extends GetxController {
  static String errorMessage = '';

  // getRoutes &&  getRoutesThroughAppServer functions returns the exact same value but they fetches from different servers

  Future<dynamic> getRoutes(LatLng launchPointLatLng, LatLng destinationLatLng,
      DateTime dateTime) async {
    final MapBoxHandler _mapBoxHandler = MapBoxHandler();
    final List<MapRoute> allRoutes = [];
    Map<String, dynamic> output = {};
    List<dynamic> routes = [];

    //All routes
    var response =
        await _mapBoxHandler.get(launchPointLatLng, destinationLatLng);
    if (response.statusCode == 200 || response.statusCode == 201) {
      output = jsonDecode(response.body);
      routes = output['routes'];
      for (final dynamic route in routes) {
        allRoutes.add(
          MapRoute(
            status: '',
            json: route,
            launchPoint: output['waypoints'][0],
            destination: output['waypoints'][1],
            launchTime: dateTime,
          ),
        );
      }
    } else {
      errorMessage = serverMessageTranslator(response.body);
      return null;
    }

    _setRoutesStatus(allRoutes);

    //Best route

    response = await _mapBoxHandler.get(launchPointLatLng, destinationLatLng,
        dateTime: DateTimeController.dateTimeToString(dateTime));
    if (response.statusCode == 200 || response.statusCode == 201) {
      output = jsonDecode(response.body);
      routes = output['routes'];
      final String timeString =
          DateTimeController.dateTimeToDisplayString(dateTime);
      for (final dynamic route in routes) {
        allRoutes.insert(
          0,
          MapRoute(
            status: 'الأفضل عند الساعة $timeString',
            json: route,
            launchPoint: output['waypoints'][0],
            destination: output['waypoints'][1],
            launchTime: dateTime,
          ),
        );
      }
    } else {
      errorMessage = serverMessageTranslator(response.body);
      return null;
    }

    return allRoutes;
  }

  Future<dynamic> getRoutesThroughAppServer(LatLng launchPointLatLng,
      LatLng destinationLatLng, DateTime dateTime) async {
    final NetworkHandler _networkHandler = NetworkHandler();
    final List<MapRoute> allRoutes = [];
    Map<String, dynamic> output = {};
    List<dynamic> routes = [];

    final Map<String, dynamic> data = {
      'sourceLongitude': launchPointLatLng.longitude.toString(),
      'sourceLatitude': launchPointLatLng.latitude.toString(),
      'destinationLongitude': destinationLatLng.longitude.toString(),
      'destinationLatitude': destinationLatLng.latitude.toString(),
    };
    //All routes
    var response = await _networkHandler.get('/mapbox/routes', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      output = jsonDecode(response.body);
      routes = output['routes'];
      for (final dynamic route in routes) {
        allRoutes.add(
          MapRoute(
            status: '',
            json: route,
            launchPoint: output['waypoints'][0],
            destination: output['waypoints'][1],
            launchTime: dateTime,
          ),
        );
      }
    } else {
      errorMessage = serverMessageTranslator(response.body);
      return null;
    }

    _setRoutesStatus(allRoutes);

    //Best route
    final String dateTimeRequestString =
        DateTimeController.dateTimeToString(dateTime);

    data.addAll({'time': dateTimeRequestString});
    response = await _networkHandler.get('/mapbox/bestroute', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      output = jsonDecode(response.body);
      routes = output['routes'];
      final String timeString =
          DateTimeController.dateTimeToDisplayString(dateTime);
      for (final dynamic route in routes) {
        allRoutes.insert(
          0,
          MapRoute(
            status: 'الأفضل عند الساعة $timeString',
            json: route,
            launchPoint: output['waypoints'][0],
            destination: output['waypoints'][1],
            launchTime: dateTime,
          ),
        );
      }
    } else {
      errorMessage = serverMessageTranslator(response.body);
      return null;
    }

    return allRoutes;
  }

  void _setRoutesStatus(List<MapRoute> allRoutes) {
    double shortest = 0;
    double longest = 0;
    double fastest = 0;
    double slowest = 0;
    //find values
    if (allRoutes.isNotEmpty) {
      shortest = allRoutes[0].json['distance'];
      fastest = allRoutes[0].json['duration'];
      for (final MapRoute mapRoute in allRoutes) {
        if (shortest > mapRoute.json['distance']) {
          shortest = mapRoute.json['distance'];
        }
        if (longest < mapRoute.json['distance']) {
          longest = mapRoute.json['distance'];
        }
        if (fastest > mapRoute.json['duration']) {
          fastest = mapRoute.json['duration'];
        }
        if (slowest < mapRoute.json['duration']) {
          slowest = mapRoute.json['duration'];
        }
      }
    }
    //set status
    for (final MapRoute mapRoute in allRoutes) {
      if (mapRoute.json['distance'] == shortest) {
        mapRoute.status += ' الأقصر';
      } else if (mapRoute.json['distance'] == longest) {
        mapRoute.status += ' الأطول';
      } else {
        mapRoute.status += ' متوسط الطول';
      }
      if (mapRoute.json['duration'] == fastest) {
        mapRoute.status += ' الأسرع';
      } else if (mapRoute.json['duration'] == slowest) {
        mapRoute.status += ' الأبطأ';
      } else {
        mapRoute.status += ' متوسط المدة';
      }
    }
  }
}
