import 'dart:convert';

import 'package:atareak/controllers/datetime_controller.dart';
import 'package:atareak/controllers/notifications_controller.dart';
import 'package:atareak/controllers/reservations_controller.dart';
import 'package:atareak/controllers/trips_controller.dart';
import 'package:atareak/models/Notification.dart' as noti;
import 'package:atareak/models/notification.dart';
import 'package:atareak/models/reservation.dart';
import 'package:atareak/models/trip.dart';
import 'package:atareak/views/components/dialogs.dart';
import 'package:atareak/views/components/list_tile.dart';
import 'package:atareak/views/components/snackbars.dart';
import 'package:atareak/views/screens/cars/car_sharing_request_datails.dart';
import 'package:atareak/views/screens/cars/cars_list.dart';
import 'package:atareak/views/screens/reservations/reservation_details.dart';
import 'package:atareak/views/screens/reservations/suggested_trips_to_reserve.dart';
import 'package:atareak/views/screens/trips/trip_details.dart';
import 'package:atareak/views/screens/user/profile.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class DismissibleNotificationTile extends StatefulWidget {
  final noti.Notification notification;

  const DismissibleNotificationTile({this.notification});

  @override
  _DismissibleNotificationTileState createState() =>
      _DismissibleNotificationTileState();
}

class _DismissibleNotificationTileState
    extends State<DismissibleNotificationTile> {
  final NotificationsController _notificationsController =
      Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() => widget.notification.read = true);
        _notificationsController.markNotificationAsRead(
            id: widget.notification.id);
        await findOutWhatShouldANotificationDo();
      },
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.3,
        secondaryActions: [
          IconSlideAction(
              onTap: () async {
                setState(() => widget.notification.read = true);
                _notificationsController.markNotificationAsRead(
                    id: widget.notification.id);
              },
              icon: Icons.done_all_rounded,
              color: kColorPrimary,
              foregroundColor: kColorWhite,
              iconWidget: const Text(
                'تعليم الإشعار كمقروء',
                style: kTextMaterialButtonStyle,
                textAlign: TextAlign.center,
              )),
        ],
        actions: [
          widget.notification.title == NotificationTitle.deleteTrip ||
                  widget.notification.title ==
                      NotificationTitle.deleteReservation
              ? IconSlideAction(
                  onTap: () async {
                    setState(() => widget.notification.read = true);
                    _notificationsController.markNotificationAsRead(
                        id: widget.notification.id);
                    Get.to(Profile(
                      userId: widget.notification.userId,
                      screenId: ScreenIdes.notificationsScreenId,
                      ratable: true,
                    ));
                  },
                  icon: Icons.star_rounded,
                  color: kColorPrimary,
                  foregroundColor: kColorWhite,
                  iconWidget: widget.notification.title ==
                          NotificationTitle.deleteReservation
                      ? const Text('تقييم الراكب',
                          style: kTextMaterialButtonStyle)
                      : const Text('تقييم السائق',
                          style: kTextMaterialButtonStyle),
                )
              : null,
        ],
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: widget.notification.read
              ? kBoxDecorationWhiteContainerWithShadow
              : kBoxDecorationSecondaryContainerWithShadow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              MyListTile(
                leading: findNotificationIcon(),
                primary: Text(widget.notification.title,
                    style: kTextNeutralStyle.copyWith(
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Text(widget.notification.message,
                  style: kTextNeutralStyleSmaller),
              const SizedBox(height: 6),
              MyListTile(
                leading: const Icon(
                  Icons.access_time_rounded,
                  color: kColorNeutral,
                  size: 15,
                ),
                primary: Text(
                    DateTimeController.fullDateTimeToDisplayString(
                        widget.notification.createdAt),
                    style: kTextNeutralStyleSmallest),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Icon findNotificationIcon() {
    switch (widget.notification.title) {
      case NotificationTitle.warning:
        return const Icon(
          Icons.warning,
          color: kColorNeutral,
        );
        break;
      case NotificationTitle.deleteTrip:
        return const Icon(
          Icons.delete_rounded,
          color: kColorNeutral,
        );
        break;
      case NotificationTitle.carShareRequest:
        return const Icon(
          Icons.drive_eta_rounded,
          color: kColorNeutral,
        );
        break;
      case NotificationTitle.deleteReservation:
        return const Icon(
          Icons.cancel_rounded,
          color: kColorNeutral,
        );
        break;
      case NotificationTitle.approveReservation:
        return const Icon(
          Icons.check_circle_rounded,
          color: kColorNeutral,
        );
        break;
      default:
        return null;
    }
  }

  Future<void> findOutWhatShouldANotificationDo() async {
    final TripsController tripsController = Get.put(TripsController());
    final ReservationsController reservationsController =
        Get.put(ReservationsController());
    switch (widget.notification.title) {
      //--------------------------------------------------//
      case NotificationTitle.warning:
        Get.off(() => Profile(screenId: ScreenIdes.profileId));
        break;
      //--------------------------------------------------//
      case NotificationTitle.deleteTrip:
        loadingDialog();
        final DateTime dateTime = DateTimeController.toDateTime(
            widget.notification.context['ReservationTime']);
        final LatLng launchPoint = LatLng(
            jsonDecode(widget.notification.context['ReservationLaunchPoint'])[
                    'location']
                .last,
            jsonDecode(widget.notification.context['ReservationLaunchPoint'])[
                    'location']
                .first);
        final LatLng dropPoint = LatLng(
            jsonDecode(widget.notification
                    .context['ReservationDestinationPoint'])['location']
                .last,
            jsonDecode(widget.notification
                    .context['ReservationDestinationPoint'])['location']
                .first);
        final List<Trip> result = await tripsController.searchTrips(
          launchPoint: launchPoint,
          destination: dropPoint,
          dateTime: dateTime,
          radios: '100',
        );
        Get.back();
        if (result == null) {
          mySnackbar(title: TripsController.errorMessage);
        } else {
          if (result.isEmpty) {
            mySnackbar(
                title: 'عذراً لم نعثر على رحلات مناسبة عوضاً عن التي تم حذفها');
          } else {
            Get.to(
              SuggestedTripsToReserve(
                pickPoint: launchPoint,
                dropPoint: dropPoint,
                dateTime: dateTime,
                allTrips: result,
              ),
            );
          }
        }
        break;
      //--------------------------------------------------//
      case NotificationTitle.carShareRequest:
        if (widget.notification.context['Type'] == 'Request') {
          Get.bottomSheet(
              CarSharingRequestDetails(notification: widget.notification));
        } else {
          Get.off(() => CarsList());
        }
        break;
      //--------------------------------------------------//
      case NotificationTitle.deleteReservation:
        loadingDialog();
        final Trip trip = await tripsController.getTripDetails(
            id: widget.notification.context['TripId']);
        Get.back();
        if (trip != null) {
          Get.to(
            TripDetails(
              trip: trip,
              screenId: ScreenIdes.tripsScreenId,
            ),
          );
        }
        break;
      //--------------------------------------------------//
      case NotificationTitle.approveReservation:
        loadingDialog();
        final Reservation reservation =
            await reservationsController.getUserReservationDetails(
                tripId: widget.notification.context['TripId']);
        final Trip trip = await tripsController.getTripDetails(
            id: widget.notification.context['TripId']);
        Get.back();
        if (reservation != null && trip != null) {
          Get.to(
            ReservationDetails(
              trip: trip,
              reservation: reservation,
              screenId: ScreenIdes.reservationsScreenId,
            ),
          );
        }
        break;
      //--------------------------------------------------//
      default:
      //--------------------------------------------------//
    }
  }
}
