import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';

class ButtonPrimaryButton extends StatelessWidget {
  const ButtonPrimaryButton({
    this.title,
    this.color,
    this.minWidth,
    this.hight,
    @required this.onPressed,
  });

  final String title;
  final Color color;
  final double minWidth;
  final double hight;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(8),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: minWidth,
          height: hight,
          child: Text(
            title,
            style: kTextPrimaryButtonStyle,
          ),
        ),
      ),
    );
  }
}
