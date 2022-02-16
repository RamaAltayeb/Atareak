import 'package:atareak/views/components/animated_glow_components.dart';
import 'package:atareak/views/utilities/assets_strings.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:flutter/material.dart';

import 'login_form.dart';

class Login extends StatelessWidget {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                height: 75,
                child: Image.asset(kImageLogo),
              ),
              const SizedBox(height: 15),
              animatedAppName(),
              const SizedBox(height: 15),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
