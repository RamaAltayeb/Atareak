import 'dart:convert';
import 'dart:typed_data';

import 'package:atareak/controllers/cars_controller.dart';
import 'package:atareak/controllers/mapbox_handler.dart';
import 'package:atareak/controllers/map_routes_controller.dart';
import 'package:atareak/controllers/trips_controller.dart';
import 'package:atareak/views/utilities/assets_strings.dart';
import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/controllers/utilities/map_consts.dart';
import 'package:atareak/controllers/user_location_controller.dart';
import 'package:atareak/models/map_route.dart';
import 'package:atareak/controllers/utilities/pref_keys.dart';
import 'package:atareak/models/trip.dart';
import 'package:atareak/views/components/bottom_navigation_bar.dart';
import 'package:atareak/views/components/dialogs.dart';
import 'package:atareak/views/components/form_fields.dart';
import 'package:atareak/views/components/snackbars.dart';
import 'package:atareak/views/screens/reservations/suggested_trips_to_reserve.dart';
import 'package:atareak/views/screens/trips/pick_a_route.dart';
import 'package:atareak/views/screens/welcome.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/server_messages_translator.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:get/get.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SymbolsMap extends StatefulWidget {
  final bool firstLoad;
  const SymbolsMap({this.firstLoad = true});
  @override
  _SymbolsMapState createState() => _SymbolsMapState();
}

class _SymbolsMapState extends State<SymbolsMap> {
  bool _symbolsImagesLoadingCrashed = false;

  MapboxMapController _mapController;

  final CarsController _carsController = Get.put(CarsController());

  final TripsController _tripsController = Get.put(TripsController());

  final UserLocationController _userLocationController =
      Get.put(UserLocationController());

  final MapRoutesController _mapRouteController =
      Get.put(MapRoutesController());

  final MapBoxHandler _mapBoxHandler = MapBoxHandler();

  // ignore: prefer_const_constructors
  Symbol _launchPoint = Symbol('0', SymbolOptions());
  // ignore: prefer_const_constructors
  Symbol _destination = Symbol('1', SymbolOptions());

  bool _launchPointLoading = false;
  bool _destinationLoading = false;

  LatLng _launchPointLatLng;
  LatLng _destinationLatLng;

  var _date = DateTime.now();
  var _time = TimeOfDay.fromDateTime(DateTime.now());

  DateTime _dateTime;

  dynamic _radios;

  bool _roleIsValid = false;
  bool _hasCarsIsValid = false;

  @override
  void initState() {
    super.initState();
    if (_time.hour == 23) {
      _date = _date.add(const Duration(days: 1));
      _time = _time.replacing(hour: 0);
    } else {
      _time = _time.replacing(hour: _time.hour + 1);
    }
    if (widget.firstLoad) {
      _userLocationController.getUserLocation(func: () {
        Get.offAll(const SymbolsMap(firstLoad: false));
      });
    }
    _setStateBools();
  }

  Future<void> _setStateBools() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _roleIsValid = prefs.getStringList(PrefKeys.userRoles).contains('Adult');
      _hasCarsIsValid = prefs.getBool(PrefKeys.userHasCars);
    });
  }

  // ignore: avoid_void_async
  void _onMapCreated(MapboxMapController controller) async {
    _mapController = controller;
    await _addSymbolsToMap();
  }

  // ignore: avoid_void_async
  void _onStyleLoadedCallback() async =>
      await _mapController.setMapLanguage('name_ar');

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

  Future<dynamic> _addSymbol(
      LatLng position, String imageSymbol, String label, String color) async {
    try {
      // ignore: unnecessary_await_in_return
      return await _mapController.addSymbol(
        SymbolOptions(
          geometry: position,
          draggable: true,
          iconImage: !_symbolsImagesLoadingCrashed ? imageSymbol : null,
          iconSize: 0.5,
          textField: label,
          textColor: color,
          textOffset: const Offset(0, 2),
        ),
      );
    } catch (ex) {
      Get.offAll(() => Welcome());
    }
  }

  Future<void> _addSymbolsToMap() async {
    await _loadSymbolsImagesFromAssets();
    final double lat = _mapController.cameraPosition.target.latitude;
    final double lng = _mapController.cameraPosition.target.longitude;
    _launchPoint = await _addSymbol(LatLng(lat + 0.005, lng + 0.005),
        'launchPointSymbol', 'نقطة الإنطلاق', kColorStringNeutral);
    _destination = await _addSymbol(LatLng(lat + 0.005, lng - 0.005),
        'destinationSymbol', 'الوجهة', kColorStringPrimary);
  }

  Future _moveSymbolToCertainPoint(String place, Symbol symbol) async {
    setState(() => symbol.id == '0'
        ? _launchPointLoading = true
        : _destinationLoading = true);
    final response = await _mapBoxHandler.getGeoCoding(place);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> output = jsonDecode(response.body);
      if (output != null) {
        if (output['features'].isEmpty) {
          mySnackbar(title: 'عذراً لم نستطع إيجاد $place');
        } else {
          final LatLng newPosition = LatLng(output['features'][0]['center'][1],
              output['features'][0]['center'][0]);

          await _mapController.updateSymbol(
            symbol,
            SymbolOptions(
              geometry: newPosition,
            ),
          );
          await _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: newPosition,
                zoom: _mapController.cameraPosition.zoom,
              ),
            ),
          );
        }
      }
    }
    setState(() => symbol.id == '0'
        ? _launchPointLoading = false
        : _destinationLoading = false);
  }

  Future<void> _getSymbolsLatLng() async {
    _launchPointLatLng = await _mapController.getSymbolLatLng(_launchPoint);
    _destinationLatLng = await _mapController.getSymbolLatLng(_destination);
  }

  Future<bool> _getDateTime() async {
    final newDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: _date,
      lastDate: DateTime(2100),
      helpText: 'اختر تاريخ الرحلة',
      fieldHintText: 'DD/MM/YYYY',
      fieldLabelText: 'التاريخ',
      confirmText: 'تأكيد',
      cancelText: 'إلغاء',
    );
    if (newDate == null) {
      return false;
    }
    final newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      helpText: 'اختر وقت الرحلة',
      confirmText: 'تأكيد',
      cancelText: 'إلغاء',
    );
    if (newTime == null) {
      return false;
    }
    final currentDate = DateTime.now();
    var currentDateTime = DateTime.now();
    currentDateTime =
        currentDateTime.subtract(currentDateTime.difference(newDate));
    final currentTime = TimeOfDay.fromDateTime(DateTime.now());
    if (newDate.isAfter(currentDate) ||
        (!newDate.isAfter(currentDateTime) &&
            (currentTime.hour < newTime.hour ||
                (currentTime.hour == newTime.hour &&
                    currentTime.minute <= newTime.minute)))) {
      _date = newDate;
      _time = newTime;
      return true;
    } else {
      mySnackbar(title: 'الوقت الذي اخترته قد مضى');
      return false;
    }
  }

  Future<void> _getRadios() async {
    final radiosController = TextEditingController();
    await myDialog(
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: doubleNumberField(
              label: 'بعد الرحل المقبول عني',
              hintText: 'البعد الإفتراضي 50 متر',
              autofocus: true,
              controller: radiosController,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              _radios = radiosController.text;
              Get.back();
            },
            child: const Text('تم'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              MapboxMap(
                accessToken: mapboxAccessToken,
                styleString: mapStyle,
                myLocationEnabled: true,
                trackCameraPosition: true,
                onMapCreated: _onMapCreated,
                onStyleLoadedCallback: _onStyleLoadedCallback,
                initialCameraPosition: CameraPosition(
                  target: userLocation,
                  zoom: 14,
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: MapBoxPlaceSearchWidget(
                      apiKey: mapboxAccessToken,
                      height: 200,
                      searchHint: 'نقطة الإنطلاق',
                      country: 'sy',
                      icon: _launchPointLoading
                          ? const Icon(Icons.circle, color: kColorNeutral)
                          : const Icon(Icons.location_on, color: kColorNeutral),
                      onSelected: (place) =>
                          _moveSymbolToCertainPoint(place.text, _launchPoint),
                      onIconTapped: (place) =>
                          _moveSymbolToCertainPoint(place, _launchPoint),
                      context: context,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: MapBoxPlaceSearchWidget(
                      apiKey: mapboxAccessToken,
                      height: 200,
                      searchHint: 'الوجهة',
                      country: 'sy',
                      icon: _destinationLoading
                          ? const Icon(Icons.circle, color: kColorPrimary)
                          : const Icon(Icons.location_on, color: kColorPrimary),
                      onSelected: (place) =>
                          _moveSymbolToCertainPoint(place.text, _destination),
                      onIconTapped: (place) =>
                          _moveSymbolToCertainPoint(place, _destination),
                      context: context,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                myDialog(
                  content: Column(
                    children: [
                      const SizedBox(height: 20),
                      createTripButton(),
                      const SizedBox(height: 10),
                      searchForATripButton(),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.add, color: kColorWhite),
            ),
            const SizedBox(height: 15),
          ],
        ),
        bottomNavigationBar: const MyBottomNavigationBar(
            screenIndex: ScreenIdes.symbolsScreenId),
      ),
    );
  }

  Widget createTripButton() {
    return TextButton.icon(
      icon: const Icon(Icons.add, color: kColorPrimary),
      label: const Text('إنشاء رحلة', style: kTextPrimaryStyle),
      onPressed: () async {
        Get.back();
        if (!_roleIsValid) {
          mySnackbar(title: 'عذراً أنت تحت السن القانوني لقيادة السيارات');
        } else if (!_hasCarsIsValid) {
          mySnackbar(
              title: 'عذراً لا يمكنك إنشاء رحلة بسبب عدم تواجد سيارة في حسابك');
        } else {
          if (await _getDateTime()) {
            loadingDialog();
            await _getSymbolsLatLng();

            _dateTime =
                _date.add(Duration(hours: _time.hour, minutes: _time.minute));
            // final List<MapRoute> allRoutes =
            //     await _mapRouteController.getRoutes(
            //         _launchPointLatLng, _destinationLatLng, _dateTime);
            final List<MapRoute> allRoutes =
                await _mapRouteController.getRoutesThroughAppServer(
                    _launchPointLatLng, _destinationLatLng, _dateTime);
            if (allRoutes == null) {
              Get.back();
              mySnackbar(title: MapRoutesController.errorMessage);
            } else {
              if (allRoutes.isEmpty) {
                Get.back();
                mySnackbar(title: 'عذراً لا يوجد طريق يصل بين النقطتين');
              } else {
                final userCars = await _carsController.getUserCars();
                Get.back();
                if (userCars == null || userCars.first == null) {
                  mySnackbar(
                      title:
                          serverMessageTranslator(CarsController.errorMessage));
                } else {
                  Get.to(
                    PickARoute(
                      allRoutes: allRoutes,
                      cars: userCars,
                    ),
                  );
                }
              }
            }
          }
        }
      },
    );
  }

  Widget searchForATripButton() {
    return TextButton.icon(
      icon: const Icon(Icons.search, color: kColorPrimary),
      label: const Text('البحث عن رحلة', style: kTextPrimaryStyle),
      onPressed: () async {
        Get.back();
        if (await _getDateTime()) {
          await _getRadios();
          loadingDialog();
          await _getSymbolsLatLng();
          _dateTime =
              _date.add(Duration(hours: _time.hour, minutes: _time.minute));
          final List<Trip> result = await _tripsController.searchTrips(
            launchPoint: _launchPointLatLng,
            destination: _destinationLatLng,
            dateTime: _dateTime,
            radios: _radios,
          );
          Get.back();
          if (result == null) {
            mySnackbar(title: TripsController.errorMessage);
          } else {
            if (result.isEmpty) {
              mySnackbar(title: 'عذراً لم نعثر على رحلات مناسبة');
            } else {
              Get.to(
                SuggestedTripsToReserve(
                  pickPoint: _launchPointLatLng,
                  dropPoint: _destinationLatLng,
                  dateTime: _dateTime,
                  allTrips: result,
                ),
              );
            }
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
