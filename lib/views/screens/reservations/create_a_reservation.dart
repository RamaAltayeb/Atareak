import 'package:atareak/controllers/reservations_controller.dart';
import 'package:atareak/views/components/primary_button.dart';
import 'package:atareak/views/components/dialogs.dart';
import 'package:atareak/views/components/form_fields.dart';
import 'package:atareak/views/components/snackbars.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAReservation extends StatefulWidget {
  final String tripId;
  final dynamic pickPoint;
  final dynamic dropPoint;
  final DateTime pickTime;
  final int maxSeatsNum;

  const CreateAReservation(
      {this.tripId,
      this.pickPoint,
      this.dropPoint,
      this.pickTime,
      this.maxSeatsNum});

  @override
  _CreateAReservationState createState() => _CreateAReservationState();
}

class _CreateAReservationState extends State<CreateAReservation> {
  final _formKey = GlobalKey<FormState>();

  final _seatsController = TextEditingController();

  final ReservationsController _reservationsController =
      Get.put(ReservationsController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: kBoxDecorationBottomSheet,
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: intNumberField(
                        label: 'عدد المقاعد',
                        minValue: 1,
                        maxValue: widget.maxSeatsNum,
                        autofocus: true,
                        hintText:
                            'يمكنك حجز من 1 إلى ${widget.maxSeatsNum} مقعد',
                        controller: _seatsController,
                      ),
                    ),
                    ButtonPrimaryButton(
                      title: 'إرسال طلب للحجز',
                      color: kColorPrimary,
                      minWidth: 350,
                      hight: 42,
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_formKey.currentState.validate()) {
                          loadingDialog();
                          final bool result =
                              await _reservationsController.createAReservation(
                            tripId: widget.tripId,
                            pickPoint: widget.pickPoint,
                            dropPoint: widget.dropPoint,
                            dateTime: widget.pickTime,
                            seats: int.parse(_seatsController.text),
                          );
                          if (result) {
                            Get.until((route) => route.isFirst);
                            mySnackbar(title: 'تم إرسال طلب الحجز بنجاح');
                          } else {
                            Get.back();
                            mySnackbar(
                                title: ReservationsController.errorMessage);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
