import 'package:atareak/controllers/notifications_controller.dart';
import 'package:atareak/controllers/users_controller.dart';
import 'package:atareak/controllers/utilities/global_variables.dart';
import 'package:atareak/views/components/primary_button.dart';
import 'package:atareak/views/components/password_field.dart';
import 'package:atareak/views/components/form_fields.dart';
import 'package:atareak/views/components/snackbars.dart';
import 'package:atareak/views/components/spinners.dart';
import 'package:atareak/views/screens/maps/symbols_map.dart';
import 'package:atareak/views/screens/user/register.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final UsersController _usersController = Get.put(UsersController());

  final NotificationsController _notificationsController =
      Get.put(NotificationsController());

  bool _waiting = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          emailField(_emailController),
          const SizedBox(height: 10),
          PasswordField(
            labelText: 'كلمة المرور',
            controller: _passwordController,
          ),
          _waiting ? const SizedBox(height: 10) : const SizedBox(height: 0),
          _waiting
              ? spinKitDoubleBounce()
              : ButtonPrimaryButton(
                  title: 'تسجيل الدخول',
                  color: kColorPrimary,
                  minWidth: 360,
                  hight: 42,
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() => _waiting = true);
                    if (_formKey.currentState.validate()) {
                      if (await _usersController.login(
                        email: _emailController.text,
                        password: _passwordController.text,
                      )) {
                        final notificationsResponse =
                            await _notificationsController.getUserNotifications(
                                page: 1);
                        if (notificationsResponse != null) {
                          globalNotifications = notificationsResponse;
                        }
                        Get.offAll(() => const SymbolsMap());
                      } else {
                        mySnackbar(title: UsersController.errorMessage);
                      }
                    }
                    setState(() => _waiting = false);
                  },
                ),
          _waiting
              ? const SizedBox(height: 0)
              : TextButton(
                  onPressed: () {
                    Get.to(Register());
                  },
                  child: const Text(
                    'ليس لديك حساب؟ سجل واحداً هنا',
                  ),
                ),
        ],
      ),
    );
  }
}
