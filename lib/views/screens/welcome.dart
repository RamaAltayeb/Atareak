import 'dart:async';

import 'package:atareak/controllers/notifications_controller.dart';
import 'package:atareak/controllers/users_controller.dart';
import 'package:atareak/controllers/utilities/global_variables.dart';
import 'package:atareak/controllers/utilities/map_consts.dart';
import 'package:atareak/controllers/utilities/pref_keys.dart';
import 'package:atareak/views/components/animated_glow_components.dart';
import 'package:atareak/views/screens/developers.dart';
import 'package:atareak/views/screens/maps/symbols_map.dart';
import 'package:atareak/views/screens/user/login.dart';
import 'package:atareak/views/utilities/assets_strings.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  final UsersController _usersController = Get.put(UsersController());

  final NotificationsController _notificationsController =
      Get.put(NotificationsController());

  bool _developersScreenDemanded = false;

  @override
  void initState() {
    super.initState();
    _startTime();
  }

  Future<Timer> _startTime() async => Timer(const Duration(seconds: 3), _route);

  Future<void> _route() async {
    if (await _usersController.isLoggedin()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await _usersController.isBlocked(
        id: prefs.getString(PrefKeys.userID),
      );
      if (response == null || !response) {
        if (response != null && !response) {
          final notifications =
              await _notificationsController.getUserNotifications(page: 1);
          if (notifications != null) {
            globalNotifications = notifications;
          }
        }
        _goToSymbolsScreen();
      } else {
        _usersController.logout();
        Get.off(() => Login());
      }
    } else {
      Get.off(() => Login());
    }
    if (_developersScreenDemanded) {
      Get.to(() => Developers());
    }
  }

  Future<void> _goToSymbolsScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userLocation = LatLng(prefs.getDouble(PrefKeys.userLocationLat),
        prefs.getDouble(PrefKeys.userLocationLng));
    Get.off(() => const SymbolsMap());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 75,
                      child: Image.asset(kImageLogo),
                    ),
                    const SizedBox(height: 15),
                    animatedAppName(),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _developersScreenDemanded = true,
                child: const Text('GP @2021', style: kTextNeutralStyle),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
