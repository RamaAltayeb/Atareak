import 'package:flutter/material.dart';

import 'assets_strings.dart';
import 'colors.dart';

BoxDecoration kBoxDecorationBackGroundImage = const BoxDecoration(
  image: DecorationImage(
    image: AssetImage(kImageBackGround),
    fit: BoxFit.cover,
  ),
);

BoxDecoration kBoxDecorationCardWhite = const BoxDecoration(
  color: kColorWhite,
  borderRadius: BorderRadius.all(
    Radius.circular(10),
  ),
  boxShadow: [
    BoxShadow(
      color: kColorBlackOverlay,
      blurRadius: 8,
      offset: Offset(2, 2),
    ),
  ],
);

BoxDecoration kBoxDecorationBottomSheet = const BoxDecoration(
  color: kColorWhite,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
  ),
);

BoxDecoration kBoxDecorationStackedContainerWhite = const BoxDecoration(
  color: kColorWhite,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  ),
  boxShadow: [
    BoxShadow(
      color: kColorBlackOverlay,
      blurRadius: 8,
      offset: Offset(2, 2),
    ),
  ],
);

BoxDecoration kBoxDecorationWhiteContainerWithShadow = const BoxDecoration(
  color: kColorWhite,
  boxShadow: [
    BoxShadow(
      color: kColorBlackOverlay,
      blurRadius: 8,
      offset: Offset(2, 2),
    ),
  ],
);

BoxDecoration kBoxDecorationSecondaryContainerWithShadow = const BoxDecoration(
  color: kColorSecondary,
  boxShadow: [
    BoxShadow(
      color: kColorBlackOverlay,
      blurRadius: 8,
      offset: Offset(2, 2),
    ),
  ],
);
