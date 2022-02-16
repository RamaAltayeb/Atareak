import 'package:atareak/controllers/cars_controller.dart';
import 'package:atareak/controllers/utilities/const_information.dart';
import 'package:atareak/views/components/primary_button.dart';
import 'package:atareak/views/components/dialogs.dart';
import 'package:atareak/views/components/form_fields.dart';
import 'package:atareak/views/components/snackbars.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateACarSharingRequest extends StatefulWidget {
  @override
  _CreateACarSharingRequestState createState() =>
      _CreateACarSharingRequestState();
}

class _CreateACarSharingRequestState extends State<CreateACarSharingRequest> {
  final _formKey = GlobalKey<FormState>();

  final _carIdController = TextEditingController();

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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: intNumberField(
                          label: 'معرف السيارة',
                          autofocus: true,
                          maxLength: kCarIdStringLength,
                          controller: _carIdController),
                    ),
                    ButtonPrimaryButton(
                      title: 'إرسال طلب مشاركة سيارة',
                      color: kColorPrimary,
                      minWidth: 350,
                      hight: 42,
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_formKey.currentState.validate()) {
                          loadingDialog();
                          final dynamic result =
                              await _carsController.createACarSharingRequest(
                            id: _carIdController.text,
                          );
                          Get.back();
                          Get.back();
                          if (result == true) {
                            mySnackbar(title: 'تم إرسال طلب المشاركة بنجاح');
                          } else {
                            mySnackbar(title: CarsController.errorMessage);
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
