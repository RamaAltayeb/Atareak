import 'package:atareak/models/car.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final Car car;

  const CarCard({this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: kBoxDecorationCardWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(
            Icons.drive_eta_rounded,
            color: kColorPrimary,
            size: 35,
          ),
          const SizedBox(height: 10),
          Text(
            '${car.model} (${car.id})',
            style: kTextPrimaryStyle,
          ),
          const SizedBox(height: 10),
          Text(
            car.isOwner ? 'مالك السيارة' : 'سيارة مستعارة',
            style: kTextNeutralStyle,
          ),
        ],
      ),
    );
  }
}
