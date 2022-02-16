import 'dart:math';

import 'package:atareak/controllers/utilities/map_consts.dart';
import 'package:atareak/controllers/utilities/pref_keys.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocationController extends GetxController {
  Future<void> setInitialLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(PrefKeys.userLocationLat, applaunchLat);
    await prefs.setDouble(PrefKeys.userLocationLng, applaunchLng);
  }

  Future<void> getUserLocation({Function func}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final Position position = await Geolocator.getCurrentPosition();
      if (sqrt(pow(
                  prefs.getDouble(PrefKeys.userLocationLat) - position.latitude,
                  2) +
              pow(
                  prefs.getDouble(PrefKeys.userLocationLng) -
                      position.longitude,
                  2)) >=
          acceptedUserLocationRadios) {
        prefs.setDouble(PrefKeys.userLocationLat, position.latitude);
        prefs.setDouble(PrefKeys.userLocationLng, position.longitude);
        userLocation = LatLng(position.latitude, position.longitude);
        func();
      }
    } catch (ex) {
      return;
    }
  }
}
