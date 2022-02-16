import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_field_styles.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final Function onChange;

  const PasswordField(
      {this.labelText, @required this.controller, this.onChange});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'رجاءً أدخل المعلومات المطلوبة';
        }
        return null;
      },
      controller: widget.controller,
      decoration: kFormTextFieldsStyle.copyWith(
        labelText: widget.labelText,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() => _obscureText = !_obscureText);
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: kColorGrey,
          ),
        ),
      ),
      onChanged: widget.onChange,
    );
  }
}
