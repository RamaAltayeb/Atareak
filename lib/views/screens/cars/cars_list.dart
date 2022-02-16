import 'dart:async';
import 'package:atareak/controllers/cars_controller.dart';
import 'package:atareak/models/car.dart';
import 'package:atareak/views/components/bottom_navigation_bar.dart';
import 'package:atareak/views/components/car_card.dart';
import 'package:atareak/views/screens/cars/create_a_car_sharing_request.dart';
import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CarsList extends StatefulWidget {
  @override
  _CarsListState createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {
  final CarsController _carsController = Get.put(CarsController());

  Future<List<Car>> _getUserCarsAndLoadList() async =>
      _carsController.getUserCars();

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
                future: _getUserCarsAndLoadList(),
                builder: (context, projectSnap) {
                  if (projectSnap.data == null) {
                    return const Center(
                      child: SpinKitDoubleBounce(color: kColorPrimary),
                    );
                  }
                  if (projectSnap.data.length == 0) {
                    return const Center(
                      child: Text(
                        'عذراً لا يوجد سيارات في حسابك',
                        style: kTextLabelStyle,
                      ),
                    );
                  }
                  if (projectSnap.data.length == 1 &&
                      projectSnap.data.first == null) {
                    return Center(
                      child: Text(
                        CarsController.errorMessage,
                        style: kTextLabelStyle,
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: projectSnap.data.length,
                      itemBuilder: (context, index) {
                        return CarCard(car: projectSnap.data[index]);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.bottomSheet(CreateACarSharingRequest());
          },
          child: const Icon(Icons.add, color: kColorWhite),
        ),
        bottomNavigationBar:
            const MyBottomNavigationBar(screenIndex: ScreenIdes.carsScreenId),
      ),
    );
  }
}
