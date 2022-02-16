import 'package:atareak/controllers/trips_controller.dart';
import 'package:atareak/controllers/utilities/const_information.dart';
import 'package:atareak/models/car.dart';
import 'package:atareak/models/map_route.dart';
import 'package:atareak/views/components/primary_button.dart';
import 'package:atareak/views/components/dialogs.dart';
import 'package:atareak/views/components/form_fields.dart';
import 'package:atareak/views/components/snackbars.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateATrip extends StatefulWidget {
  final MapRoute mapRoute;
  final List<Car> cars;

  const CreateATrip({this.mapRoute, @required this.cars});

  @override
  _CreateATripState createState() => _CreateATripState();
}

class _CreateATripState extends State<CreateATrip> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _dropdownCars = [];
  String _selectedCar;

  final _seatsController = TextEditingController();
  final _priceController = TextEditingController();

  final TripsController _tripsController = Get.put(TripsController());

  @override
  void initState() {
    super.initState();
    for (final Car car in widget.cars) {
      _dropdownCars.add('(${car.id}) ${car.model}');
    }
    _selectedCar = _dropdownCars.first;
  }

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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Text('اختر السيارة:', style: kTextButtonStyle),
                          const SizedBox(width: 10),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.58,
                            decoration: BoxDecoration(
                              color: kColorWhite,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: DropdownButton<String>(
                                value: _selectedCar,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                elevation: 16,
                                onChanged: (value) {
                                  setState(() => _selectedCar = value);
                                },
                                items: _dropdownCars
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: intNumberField(
                          label: 'عدد المقاعد',
                          minValue: 1,
                          controller: _seatsController),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: doubleNumberField(
                          label: 'ثمن الرحلة',
                          maxValue: widget.mapRoute.json['distance'] / 2,
                          hintText:
                              'الثمن المسموح للرحلة من 0 حتى ${widget.mapRoute.json['distance']}',
                          controller: _priceController),
                    ),
                    ButtonPrimaryButton(
                      title: 'إنشاء رحلة',
                      color: kColorPrimary,
                      minWidth: 350,
                      hight: 42,
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_formKey.currentState.validate()) {
                          loadingDialog();
                          final bool result =
                              await _tripsController.createATrip(
                            carId: _selectedCar.substring(
                                1, kCarIdStringLength + 1),
                            seats: _seatsController.text,
                            price: _priceController.text,
                            route: widget.mapRoute,
                          );
                          if (result) {
                            Get.until((route) => route.isFirst);
                            mySnackbar(title: 'تم إنشاء الرحلة بنجاح');
                          } else {
                            Get.back();
                            mySnackbar(title: TripsController.errorMessage);
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
