import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/models/car.dart';
import 'package:atareak/models/map_route.dart';
import 'package:atareak/views/components/route_card.dart';
import 'package:atareak/views/screens/maps/routes_map.dart';
import 'package:atareak/views/screens/trips/create_a_trip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickARoute extends StatelessWidget {
  final List<MapRoute> allRoutes;
  final List<Car> cars;

  const PickARoute({this.allRoutes, this.cars});

  @override
  Widget build(BuildContext context) {
    final List<RouteCard> routesCards = [];
    for (final MapRoute mapRoute in allRoutes) {
      routesCards.add(
        RouteCard(
          mapRoute: mapRoute,
          onButtonPressed: () async {
            Get.bottomSheet(CreateATrip(
              mapRoute: mapRoute,
              cars: cars,
            ));
          },
        ),
      );
    }
    return RouteMap(
      allRoutes: allRoutes,
      cards: routesCards,
      screenId: ScreenIdes.symbolsScreenId,
    );
  }
}
