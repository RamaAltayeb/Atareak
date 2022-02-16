import 'package:atareak/views/utilities/colors.dart';
import 'package:flutter/material.dart';

ShapeBorder materialButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(5),
);

ButtonStyle outilnedDangerButtonStyle = OutlinedButton.styleFrom(
  side: const BorderSide(color: kColorDanger),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  backgroundColor: kColorWhite,
  shadowColor: kColorBlackOverlay,
  elevation: 2,
);

ButtonStyle outilnedWhiteButtonStyle = OutlinedButton.styleFrom(
  side: const BorderSide(color: kColorWhite),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
);
