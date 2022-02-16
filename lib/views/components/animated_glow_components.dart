import 'package:atareak/views/components/animated_glow.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:flutter/material.dart';

Widget animatedAppName() {
  return AnimatedGlow(
    colors: const [kColorPrimary, kColorWhite, kColorPrimary],
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'عَ',
          style: TextStyle(fontSize: 40),
        ),
        Text(
          'طريقك',
          style: TextStyle(fontSize: 40),
        ),
      ],
    ),
  );
}
