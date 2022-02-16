import 'dart:typed_data';

import 'package:atareak/controllers/utilities/map_consts.dart';
import 'package:atareak/models/map_route.dart';
import 'package:atareak/views/components/animation_slider.dart';
import 'package:atareak/views/components/bottom_navigation_bar.dart';
import 'package:atareak/views/utilities/assets_strings.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class RouteMap extends StatefulWidget {
  final List<MapRoute> allRoutes;
  final List<Widget> cards;
  final int screenId;
  final double height;

  const RouteMap(
      {this.allRoutes, this.cards, this.screenId, this.height = 150});

  @override
  _RouteMapState createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  bool _symbolsImagesLoadingCrashed = false;

  MapboxMapController _mapController;

  // ignore: avoid_void_async
  void _onMapCreated(MapboxMapController controller) async {
    _mapController = controller;
    await _loadSymbolsImagesFromAssets();
    await _addSymbolsToMap(widget.allRoutes.first);
    if (widget.allRoutes.isNotEmpty) {
      await _updateCameraPosition(widget.allRoutes.first);
      await _drawARoute(widget.allRoutes.first);
    }
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
        body: SafeArea(
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              MapboxMap(
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
              Container(
                height: widget.height,
                child: AnimationSlider(
                  onPageChanged: (index) async {
                    await _addSymbolsToMap(widget.allRoutes.elementAt(index));
                    await _updateCameraPosition(
                        widget.allRoutes.elementAt(index));
                    await _drawARoute(widget.allRoutes.elementAt(index));
                  },
                  children: widget.cards,
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
