import 'package:atareak/views/components/spinners.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future myDialog({Widget content}) {
  return Get.defaultDialog(
    titleStyle: const TextStyle(fontSize: 0),
    content: Directionality(
      textDirection: TextDirection.rtl,
      child: content,
    ),
  );
}

Future loadingDialog() {
  return Get.dialog(
    spinKitDoubleBounce(),
    barrierDismissible: false,
    barrierColor: kColorBlackOverlay,
  );
}
