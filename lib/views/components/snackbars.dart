import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void mySnackbar({String title}) {
  return Get.snackbar(
    '',
    '',
    titleText: Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        title,
        style: kTextLabelStyle,
      ),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: kColorWhite,
    overlayBlur: 0.5,
    overlayColor: kColorBlackOverlay,
  );
}
