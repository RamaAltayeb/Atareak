import 'package:atareak/views/components/app_bar.dart';
import 'package:atareak/views/components/bottom_navigation_bar.dart';
import 'package:atareak/views/components/reservation_widgets.dart';
import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';

class TripReservationRequests extends StatelessWidget {
  final List<ReservationInfoForDriver> reservationsCards;

  const TripReservationRequests({this.reservationsCards});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: myAppBar(title: 'طلبات الحجوزات'),
        body: SafeArea(
          child: reservationsCards.isNotEmpty
              ? ListView(
                  children: reservationsCards,
                )
              : const Center(
                  child: Text(
                    'لا يوجد حجوزات بعد',
                    style: kTextLabelStyle,
                  ),
                ),
        ),
        bottomNavigationBar: const MyBottomNavigationBar(
          screenIndex: ScreenIdes.tripsScreenId,
        ),
      ),
    );
  }
}
