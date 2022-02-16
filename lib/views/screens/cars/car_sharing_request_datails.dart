import 'package:atareak/controllers/cars_controller.dart';
import 'package:atareak/models/Notification.dart' as noti;
import 'package:atareak/views/components/dialogs.dart';
import 'package:atareak/views/components/primary_button.dart';
import 'package:atareak/views/components/snackbars.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarSharingRequestDetails extends StatelessWidget {
  final noti.Notification notification;

  CarSharingRequestDetails({this.notification});

  final CarsController _carsController = Get.put(CarsController());

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('طلب مشاركة سيارة:', style: kTextLabelStyle),
                        const SizedBox(height: 10),
                        Text(notification.message, style: kTextNeutralStyle),
                      ],
                    ),
                  ),
                  ButtonPrimaryButton(
                    title: 'قبول الطلب',
                    color: kColorPrimary,
                    minWidth: 350,
                    hight: 42,
                    onPressed: () async {
                      loadingDialog();
                      final dynamic result =
                          await _carsController.acceptACarSharingRequest(
                        carId: notification.context['Car']['Id'],
                        clientId: notification.userId,
                      );
                      Get.back();
                      Get.back();
                      if (result == true) {
                        mySnackbar(title: 'تم قبول الطلب');
                      } else {
                        mySnackbar(title: CarsController.errorMessage);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
