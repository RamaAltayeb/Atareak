import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:atareak/views/utilities/colors.dart';

PreferredSizeWidget myAppBar({String title = ''}) {
  return AppBar(
    backgroundColor: kColorWhite,
    iconTheme: const IconThemeData(color: kColorPrimary),
    title: Text(
      title,
      style: kTextLabelStyle,
    ),
  );
}
