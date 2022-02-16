import 'dart:async';
import 'package:atareak/controllers/trips_controller.dart';
import 'package:atareak/models/trip.dart';
import 'package:atareak/views/components/bottom_navigation_bar.dart';
import 'package:atareak/views/components/trip_widgets.dart';
import 'package:atareak/views/screens/trips/trip_details.dart';
import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class TripsList extends StatefulWidget {
  @override
  _TripsListState createState() => _TripsListState();
}

class _TripsListState extends State<TripsList> {
  final List<Trip> _trips = [];

  final List<int> _pagesNumbers = [1];

  int _nextPage = 2;

  bool _lazyListIsLoading = false;

  bool _reachedTheEnd = false;

  bool _firstFetch = true;

  final TripsController _tripsController = Get.put(TripsController());

  final ScrollController _scrollController = ScrollController();

  Future<List<Trip>> _getUserTripsAndLoadList() =>
      _tripsController.getUserTrips(page: 1);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _onScroll() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_reachedTheEnd) {
      setState(() {
        _lazyListIsLoading = true;
      });
      await _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (!_pagesNumbers.contains(_nextPage)) {
      _pagesNumbers.add(_nextPage);
      final List<Trip> pageTrips =
          await _tripsController.getUserTrips(page: _nextPage);
      _nextPage++;
      setState(() {
        pageTrips.isEmpty ? _reachedTheEnd = true : _trips.addAll(pageTrips);
        _lazyListIsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              FutureBuilder(
                future: _firstFetch ? _getUserTripsAndLoadList() : null,
                builder: (context, projectSnap) {
                  if (projectSnap.data == null) {
                    return const Center(
                      child: SpinKitDoubleBounce(color: kColorPrimary),
                    );
                  }
                  if (projectSnap.data.length == 0 && _firstFetch) {
                    return const Center(
                      child: Text('يمكنك إنشاء رحلات من قسم الخريطة',
                          style: kTextLabelStyle),
                    );
                  }
                  if (projectSnap.data.length == 1 &&
                      projectSnap.data.first == null) {
                    return Center(
                      child: Text(
                        TripsController.errorMessage,
                        style: kTextLabelStyle,
                      ),
                    );
                  }
                  if (_firstFetch) {
                    _trips.addAll(projectSnap.data);
                  }
                  _firstFetch = false;
                  return Expanded(child: _lazyList());
                },
              )
            ],
          ),
        ),
        bottomNavigationBar:
            const MyBottomNavigationBar(screenIndex: ScreenIdes.tripsScreenId),
      ),
    );
  }

  ListView _lazyList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _lazyListIsLoading ? _trips.length + 1 : _trips.length,
      itemBuilder: (context, index) {
        if (_trips.length == index) {
          return Container(
            height: 100,
            child: const Center(
              child: SpinKitDoubleBounce(color: kColorPrimary),
            ),
          );
        }
        return TripCardForDriver(
          trip: _trips[index],
          onButtonPressed: () {
            Get.to(
              TripDetails(
                trip: _trips[index],
                screenId: ScreenIdes.tripsScreenId,
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
