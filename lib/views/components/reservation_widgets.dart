import 'package:atareak/controllers/datetime_controller.dart';
import 'package:atareak/models/reservation.dart';
import 'package:atareak/models/trip.dart';
import 'package:atareak/views/components/list_tile.dart';
import 'package:atareak/views/components/person_list_tiel.dart';
import 'package:atareak/views/components/reservation_list_tiels.dart';
import 'package:atareak/views/components/snackbars.dart';
import 'package:atareak/views/components/trip_list_tiles.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:atareak/views/utilities/buttons_styles.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReservationCardForClient extends StatelessWidget {
  final Reservation reservation;
  final Function onButtonPressed;

  const ReservationCardForClient({this.reservation, this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: kBoxDecorationCardWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pickPointListTile(
                name: reservation.pickPoint['name'],
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(height: 10),
              dropPointListTile(
                name: reservation.dropPoint['name'],
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(height: 10),
              launchTimeListTile(DateTimeController.fullDateTimeToDisplayString(
                  reservation.pickTime)),
              const SizedBox(height: 10),
              reservationSeatsListTile(reservation.seats),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              reservation.approved
                  ? const Icon(Icons.check_circle_rounded, color: kColorPrimary)
                  : const Icon(Icons.access_time_rounded, color: kColorPrimary),
              TextButton(
                onPressed: onButtonPressed,
                child: const Text('التفاصيل'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------//

class ReservationInfoForDriver extends StatefulWidget {
  final Reservation reservation;
  final Trip trip;
  final Function onButtonPressed;

  const ReservationInfoForDriver(
      {this.reservation, this.trip, this.onButtonPressed});

  @override
  _ReservationInfoForDriverState createState() =>
      _ReservationInfoForDriverState();
}

class _ReservationInfoForDriverState extends State<ReservationInfoForDriver> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    personListTiel(
                      name: widget.reservation.userName,
                      image: widget.reservation.userImage,
                      id: widget.reservation.userId,
                      screenId: ScreenIdes.tripsScreenId,
                      ratable: widget.reservation.approved,
                    ),
                    const SizedBox(height: 10),
                    pickPointListTile(
                      name: widget.reservation.pickPoint['name'],
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    const SizedBox(height: 10),
                    dropPointListTile(
                      name: widget.reservation.dropPoint['name'],
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    const SizedBox(height: 10),
                    reservationSeatsListTile(widget.reservation.seats),
                  ],
                ),
                widget.reservation.approved
                    ? const Icon(Icons.check_circle_rounded,
                        color: kColorPrimary)
                    : MaterialButton(
                        color: kColorPrimary,
                        disabledColor: kColorSecondary,
                        shape: materialButtonShape,
                        onPressed: widget.reservation.seats >
                                    widget.trip.availableSeats ||
                                widget.trip.launchTime.isBefore(DateTime.now())
                            ? null
                            : () {
                                if (widget.trip.availableSeats <= 0) {
                                  Get.back();
                                  mySnackbar(
                                      title: 'اكنمل عدد المقاعد المحجوزة');
                                } else {
                                  widget.onButtonPressed();
                                  setState(
                                      () => widget.reservation.approved = true);
                                }
                              },
                        child: const Text(
                          'اقبل الحجز',
                          style: kTextMaterialButtonStyle,
                        ),
                      ),
              ],
            ),
          ),
          const Divider(thickness: 2),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------//

class AllReservationDetails extends StatelessWidget {
  final String tripId;
  final Reservation reservation;

  const AllReservationDetails({this.tripId, this.reservation});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Divider(),
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          child: const Text(
            'تفاصيل الحجز',
            style: kTextLabelStyle,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 15),
        MyListTile(
          leading: reservation.approved
              ? const Icon(Icons.check_circle_rounded,
                  color: kColorPrimary, size: 20)
              : const Icon(Icons.access_time_rounded,
                  color: kColorPrimary, size: 20),
          primary: reservation.approved
              ? Text(
                  'الحجز مقبول',
                  style: kTextPrimaryStyle.copyWith(fontSize: 16),
                )
              : Text(
                  'طلب الحجز قيد الانتظار',
                  style: kTextPrimaryStyle.copyWith(fontSize: 16),
                ),
        ),
        const SizedBox(height: 15),
        pickPointListTile(
          name: reservation.pickPoint['name'],
          width: MediaQuery.of(context).size.width / 2,
        ),
        const SizedBox(height: 15),
        dropPointListTile(
          name: reservation.dropPoint['name'],
          width: MediaQuery.of(context).size.width / 2,
        ),
        const SizedBox(height: 15),
        reservationSeatsListTile(reservation.seats),
        const SizedBox(height: 15),
      ],
    );
  }
}
