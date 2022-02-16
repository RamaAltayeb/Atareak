import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

InputDecoration kFormTextFieldsStyle = InputDecoration(
  hintStyle: kTextHintTextFieldStyle,
  contentPadding: const EdgeInsets.all(10),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: kColorPrimary, width: 2),
    borderRadius: BorderRadius.circular(8),
  ),
);
