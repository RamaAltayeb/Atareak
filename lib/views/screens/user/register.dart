import 'package:atareak/views/screens/user/register_form.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: kBoxDecorationBackGroundImage,
          constraints: const BoxConstraints.expand(),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 45),
              const Text(
                'تسجيل حساب',
                style: kTextHeaddingStyle,
                ),
              const SizedBox(height: 10),
              Expanded(
                child: RegisterForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}