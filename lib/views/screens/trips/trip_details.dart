import 'dart:typed_data';

import 'package:atareak/controllers/trips_controller.dart';
import 'package:atareak/models/reservation.dart';
import 'package:atareak/models/user.dart';
import 'package:atareak/views/components/app_bar.dart';
import 'package:atareak/views/components/dialogs.dart';
import 'package:atareak/views/components/reservation_widgets.dart';
import 'package:atareak/views/components/snackbars.dart';
import 'package:atareak/views/components/trip_widgets.dart';
import 'package:atareak/views/screens/trips/trip_reservation_requests.dart';
import 'package:atareak/views/screens/trips/trips_list.dart';
import 'package:atareak/views/utilities/assets_strings.dart';
import 'package:atareak/views/utilities/buttons_styles.dart';
import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:atareak/controllers/utilities/map_consts.dart';
import 'package:atareak/models/map_route.dart';
import 'package:atareak/models/trip.dart';
import 'package:atareak/views/components/bottom_navigation_bar.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class TripDetails extends StatefulWidget {
  final Trip trip;
  final int screenId;
  final bool ratable;

  const TripDetails({
    this.trip,
    this.screenId,
    this.ratable = true,
  });

  @override
  _TripDetailsState createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  bool _symbolsImagesLoadingCrashed = false;

  MapboxMapController _mapController;

  final TripsController _tripsController = Get.put(TripsController());

  // ignore: avoid_void_async
  void _onMapCreated(MapboxMapController controller) async {
    _mapController = controller;
    await _loadSymbolsImagesFromAssets();
    await _addSymbolsToMap(widget.trip.route);
    await _updateCameraPosition(widget.trip.route);
    await _drawARoute(widget.trip.route);
  }

  // ignore: avoid_void_async
  void _onStyleLoadedCallback() async =>
      await _mapController.setMapLanguage('name_ar');

  Future _drawARoute(MapRoute mapRoute) async {
    await _mapController.clearLines();
    final List<dynamic> coordinates = mapRoute.json['geometry']['coordinates'];
    final List<LatLng> geometry = [];
    for (final List<dynamic> point in coordinates) {
      geometry.add(LatLng(point.last, point.first));
    }
    await _add(geometry);
  }

  Future _add(List<LatLng> geometry) async {
    await _mapController.addLine(LineOptions(
      geometry: geometry,
      lineColor: kColorStringPrimary,
      lineWidth: 6,
      lineOpacity: 0.5,
    ));
  }

  Future _loadSymbolsImagesFromAssets() async {
    await _addImageFromAsset('launchPointSymbol', kImageSymbolNeutral);
    await _addImageFromAsset('destinationSymbol', kImageSymbolPrimary);
  }

  Future<void> _addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    try {
      // ignore: unnecessary_await_in_return
      await _mapController.addImage(name, list);
    } catch (ex) {
      _symbolsImagesLoadingCrashed = true;
    }
  }

  Future _addSymbol(
      LatLng position, String imageSymbol, String label, String color) async {
    try {
      await _mapController.addSymbol(
        SymbolOptions(
          geometry: position,
          iconImage: !_symbolsImagesLoadingCrashed ? imageSymbol : null,
          iconSize: 0.5,
          textField: label,
          textColor: color,
          textOffset: const Offset(0, 2),
        ),
      );
    } catch (ex) {
      ex.printStackTrace();
    }
  }

  Future _addSymbolsToMap(MapRoute route) async {
    await _mapController.clearSymbols();
    await _addSymbol(
        LatLng(route.launchPoint['location'].last,
            route.launchPoint['location'].first),
        'launchPointSymbol',
        'نقطة الإنطلاق',
        kColorStringNeutral);
    await _addSymbol(
        LatLng(route.destination['location'].last,
            route.destination['location'].first),
        'destinationSymbol',
        'الوجهة',
        kColorStringPrimary);
  }

  Future _updateCameraPosition(MapRoute route) async {
    await _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: route.launchPoint['location'].last >
                  route.destination['location'].last
              ? LatLng(route.launchPoint['location'].last,
                  route.launchPoint['location'].first)
              : route.launchPoint['location'].last <
                      route.destination['location'].last
                  ? LatLng(route.destination['location'].last,
                      route.destination['location'].first)
                  : LatLng(route.destination['location'].last + 0.02,
                      route.destination['location'].first),
          southwest: route.launchPoint['location'].last <
                  route.destination['location'].last
              ? LatLng(route.launchPoint['location'].last,
                  route.launchPoint['location'].first)
              : route.launchPoint['location'].last >
                      route.destination['location'].last
                  ? LatLng(route.destination['location'].last,
                      route.destination['location'].first)
                  : LatLng(route.destination['location'].last - 0.02,
                      route.destination['location'].first),
        ),
        left: 50,
        right: 50,
        top: 50,
        bottom: 50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: myAppBar(title: 'تفاصيل الرحلة'),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: MapboxMap(
                  accessToken: mapboxAccessToken,
                  styleString: mapStyle,
                  trackCameraPosition: true,
                  onMapCreated: _onMapCreated,
                  onStyleLoadedCallback: _onStyleLoadedCallback,
                  initialCameraPosition: CameraPosition(
                    target: userLocation,
                    zoom: 14,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      AllTripDetails(
                        trip: widget.trip,
                        screenId: ScreenIdes.tripsScreenId,
                        ratable: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            color: kColorPrimary,
                            shape: materialButtonShape,
                            onPressed: () async {
                              loadingDialog();
                              final List<Reservation> reservations =
                                  await _tripsController
                                      .getTripReservationRequests(
                                id: widget.trip.id,
                              );
                              Get.back();
                              final List<ReservationInfoForDriver>
                                  reservationsCards = [];
                              for (final Reservation reservation
                                  in reservations) {
                                reservationsCards.add(
                                  ReservationInfoForDriver(
                                    reservation: reservation,
                                    trip: widget.trip,
                                    onButtonPressed: () async {
                                      loadingDialog();
                                      final bool result = await _tripsController
                                          .approveReservation(
                                              tripId: widget.trip.id,
                                              clientId: reservation.userId);                                      
                                      Get.back();
                                      if (result == true) {
                                        setState(() {
                                          reservation.approved = true;
                                          widget.trip.availableSeats -=
                                              reservation.seats;
                                          widget.trip.users.add(Client(
                                              id: reservation.userId,
                                              name: reservation.userName,
                                              seats: reservation.seats));
                                        });
                                        mySnackbar(
                                            title:
                                                'تم إرسال إشعار إلى ${reservation.userName} بقبول الحجز');
                                      } else {
                                        mySnackbar(
                                            title:
                                                TripsController.errorMessage);
                                      }
                                    },
                                  ),
                                );
                              }
                              Get.to(
                                TripReservationRequests(
                                  reservationsCards: reservationsCards,
                                ),
                              );
                            },
                            child: const Text(
                              'طلبات الحجز',
                              style: kTextMaterialButtonStyle,
                            ),
                          ),
                          OutlinedButton(
                            style: outilnedDangerButtonStyle,
                            onPressed: () async {
                              loadingDialog();
                              final dynamic result = await _tripsController
                                  .deleteTrip(id: widget.trip.id);
                              Get.back();
                              if (result == null) {
                                mySnackbar(title: TripsController.errorMessage);
                              } else {
                                if (result) {
                                  Get.off(TripsList());
                                  mySnackbar(title: 'تم حذف الرحلة بنجاح');
                                } else {
                                  mySnackbar(title: 'تعذر حذف الرحلة');
                                }
                              }
                            },
                            child: const Text(
                              'حذف الرحلة',
                              style: kTextOutlinedDangerButtonStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            MyBottomNavigationBar(screenIndex: widget.screenId),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
