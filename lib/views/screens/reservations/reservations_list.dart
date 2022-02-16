import 'dart:async';
import 'package:atareak/controllers/reservations_controller.dart';
import 'package:atareak/controllers/trips_controller.dart';
import 'package:atareak/models/reservation.dart';
import 'package:atareak/models/trip.dart';
import 'package:atareak/views/components/bottom_navigation_bar.dart';
import 'package:atareak/views/components/dialogs.dart';
import 'package:atareak/views/components/reservation_widgets.dart';
import 'package:atareak/views/screens/reservations/reservation_details.dart';
import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class ReservationsList extends StatefulWidget {
  @override
  _ReservvationsListState createState() => _ReservvationsListState();
}

class _ReservvationsListState extends State<ReservationsList> {
  final List<Reservation> _reservations = [];

  final List<int> _pagesNumbers = [1];

  int _nextPage = 2;

  bool _lazyListIsLoading = false;

  bool _reachedTheEnd = false;

  bool _firstFetch = true;

  final TripsController _tripsController = Get.put(TripsController());

  final ReservationsController _reservationsController =
      Get.put(ReservationsController());

  final ScrollController _scrollController = ScrollController();

  Future<List<Reservation>> _getUserReservationsAndLoadList() async =>
      _reservationsController.getUserReservations(page: 1);

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
      final List<Reservation> pageReservations =
          await _reservationsController.getUserReservations(page: _nextPage);
      _nextPage++;
      setState(() {
        pageReservations.isEmpty
            ? _reachedTheEnd = true
            : _reservations.addAll(pageReservations);
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
                future: _firstFetch ? _getUserReservationsAndLoadList() : null,
                builder: (context, projectSnap) {
                  if (projectSnap.data == null) {
                    return const Center(
                      child: SpinKitDoubleBounce(color: kColorPrimary),
                    );
                  }
                  if (projectSnap.data.length == 0 && _firstFetch) {
                    return const Center(
                      child: Text(
                        'يمكنك الحجز في رحلة من قسم الخريطة',
                        style: kTextLabelStyle,
                      ),
                    );
                  }
                  if (projectSnap.data.length == 1 &&
                      projectSnap.data.first == null) {
                    return Center(
                      child: Text(
                        ReservationsController.errorMessage,
                        style: kTextLabelStyle,
                      ),
                    );
                  }
                  if (_firstFetch) {
                    _reservations.addAll(projectSnap.data);
                  }
                  _firstFetch = false;
                  return Expanded(child: _lazyList());
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: const MyBottomNavigationBar(
            screenIndex: ScreenIdes.reservationsScreenId),
      ),
    );
  }

  ListView _lazyList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount:
          _lazyListIsLoading ? _reservations.length + 1 : _reservations.length,
      itemBuilder: (context, index) {
        if (_reservations.length == index) {
          return Container(
            height: 100,
            child: const Center(
              child: SpinKitDoubleBounce(color: kColorPrimary),
            ),
          );
        }
        return ReservationCardForClient(
          reservation: _reservations[index],
          onButtonPressed: () async {
            loadingDialog();
            final Trip trip = await _tripsController.getTripDetails(
                id: _reservations[index].tripId);
            Get.back();
            Get.to(
              ReservationDetails(
                trip: trip,
                reservation: _reservations[index],
                screenId: ScreenIdes.reservationsScreenId,
                ratable: _reservations[index].approved,
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
