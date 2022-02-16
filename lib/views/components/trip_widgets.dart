import 'package:atareak/controllers/datetime_controller.dart';
import 'package:atareak/models/trip.dart';
import 'package:atareak/models/user.dart';
import 'package:atareak/views/components/trip_list_tiles.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:atareak/views/utilities/buttons_styles.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:atareak/views/utilities/transformers.dart';
import 'package:flutter/material.dart';

class TripCardForClient extends StatelessWidget {
  final Trip trip;
  final Function onButtonPressed;

  const TripCardForClient({this.trip, this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: kBoxDecorationCardWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 10),
          launchPointListTile(
            name: trip.launchPoint['name'],
            width: MediaQuery.of(context).size.width / 1.5,
          ),
          const SizedBox(height: 10),
          destinationListTile(
            name: trip.destination['name'],
            width: MediaQuery.of(context).size.width / 1.5,
          ),
          const SizedBox(height: 10),
          launchTimeListTile(
            DateTimeController.fullDateTimeToDisplayString(trip.launchTime),
          ),
          const SizedBox(height: 10),
          availableSeatsNumListTile(trip.availableSeats.toString()),
          const SizedBox(height: 10),
          seatPriceListTile(trip.seatPrice.toString()),
          const SizedBox(height: 10),
          carListTile(trip.car),
          const SizedBox(height: 10),
          driverListTile(
            text: trip.driver.name,
            id: trip.driver.id,
            screenId: ScreenIdes.symbolsScreenId,
          ),
          const SizedBox(height: 10),
          MaterialButton(
            color: kColorPrimary,
            shape: materialButtonShape,
            onPressed: onButtonPressed,
            child: const Text(
              'احجز الآن',
              style: kTextMaterialButtonStyle,
            ),
          ),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------//

class TripCardForDriver extends StatelessWidget {
  final Trip trip;
  final Function onButtonPressed;

  const TripCardForDriver({this.trip, this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: kBoxDecorationCardWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 10),
          launchPointListTile(
            name: trip.launchPoint['name'],
            width: MediaQuery.of(context).size.width / 1.4,
          ),
          const SizedBox(height: 10),
          destinationListTile(
            name: trip.destination['name'],
            width: MediaQuery.of(context).size.width / 1.4,
          ),
          const SizedBox(height: 10),
          launchTimeListTile(
            DateTimeController.fullDateTimeToDisplayString(trip.launchTime),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              totalSeatsNumListTile(trip.totalSeats.toString()),
              const SizedBox(width: 10),
              totalPriceListTile(trip.totalPrice.toString()),
            ],
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onButtonPressed,
            child: const Text('التفاصيل'),
          ),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------//

class AllTripDetails extends StatefulWidget {
  final Trip trip;
  final int screenId;
  final bool ratable;

  const AllTripDetails({this.trip, this.screenId, this.ratable});

  @override
  _AllTripDetailsState createState() => _AllTripDetailsState();
}

class _AllTripDetailsState extends State<AllTripDetails> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> clients = [];
    for (final Client client in widget.trip.users) {
      clients.add(
        Column(
          children: [
            clientListTile(
              client: client,
              screenId: widget.screenId,
              ratable: widget.ratable &&
                  widget.trip.launchTime.isBefore(DateTime.now()),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تفاصيل الرحلة',
          style: kTextLabelStyle,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 15),
        driverListTile(
          text: widget.trip.driver.name,
          id: widget.trip.driver.id,
          screenId: ScreenIdes.reservationsScreenId,
          ratable:
              widget.ratable && widget.trip.launchTime.isBefore(DateTime.now()),
        ),
        const SizedBox(height: 15),
        launchPointListTile(
          name: widget.trip.launchPoint['name'],
          width: MediaQuery.of(context).size.width / 1.2,
        ),
        const SizedBox(height: 15),
        destinationListTile(
          name: widget.trip.destination['name'],
          width: MediaQuery.of(context).size.width / 1.2,
        ),
        const SizedBox(height: 15),
        launchTimeListTile(
          DateTimeController.fullDateTimeToDisplayString(
            widget.trip.launchTime,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            totalSeatsNumListTile(widget.trip.totalSeats.toString()),
            const SizedBox(width: 15),
            totalPriceListTile(widget.trip.totalPrice.toString()),
            const SizedBox(width: 15),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            availableSeatsNumListTile(widget.trip.availableSeats.toString()),
            const SizedBox(width: 15),
            seatPriceListTile(widget.trip.seatPrice.toString()),
            const SizedBox(width: 15),
          ],
        ),
        const SizedBox(height: 15),
        distanceListTile(distanceTransform(widget.trip.distance)),
        const SizedBox(height: 15),
        durationListTile(durationTransform(widget.trip.duration)),
        const SizedBox(height: 15),
        carListTile(widget.trip.car),
        const SizedBox(height: 15),
        const Divider(),
        const SizedBox(height: 10),
        const Text(
          'الركاب',
          style: kTextLabelStyle,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        clients.isEmpty
            ? const Text('لا يوجد ركاب بعد', style: kTextNeutralStyleSmaller)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: clients,
              ),
        const SizedBox(height: 15),
      ],
    );
  }
}
