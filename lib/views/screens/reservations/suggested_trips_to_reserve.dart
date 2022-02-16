import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/models/map_route.dart';
import 'package:atareak/models/trip.dart';
import 'package:atareak/views/components/trip_widgets.dart';
import 'package:atareak/views/screens/maps/routes_map.dart';
import 'package:atareak/views/screens/reservations/create_a_reservation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestedTripsToReserve extends StatelessWidget {
  final dynamic pickPoint;
  final dynamic dropPoint;
  final DateTime dateTime;
  final List<Trip> allTrips;

  const SuggestedTripsToReserve(
      {this.pickPoint, this.dropPoint, this.dateTime, this.allTrips});

  @override
  Widget build(BuildContext context) {
    final List<MapRoute> allRoutes = [];
    for (final Trip trip in allTrips) {
      allRoutes.add(trip.route);
    }
    final List<TripCardForClient> tripCards = [];
    for (final Trip trip in allTrips) {
      tripCards.add(
        TripCardForClient(
          trip: trip,
          onButtonPressed: () async {
            Get.bottomSheet(
              CreateAReservation(
                tripId: trip.id,
                pickPoint: pickPoint,
                dropPoint: dropPoint,
                pickTime: trip.launchTime,
                maxSeatsNum: trip.availableSeats,
              ),
            );
          },
        ),
      );
    }
    return RouteMap(
      allRoutes: allRoutes,
      cards: tripCards,
      screenId: ScreenIdes.symbolsScreenId,
      height: 300,
    );
  }
}
