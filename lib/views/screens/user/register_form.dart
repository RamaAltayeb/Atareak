import 'package:atareak/controllers/users_controller.dart';
import 'package:atareak/views/components/snackbars.dart';
import 'package:atareak/views/components/spinners.dart';
import 'package:atareak/views/components/form_fields.dart';
import 'package:atareak/views/screens/maps/symbols_map.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:atareak/views/components/primary_button.dart';
import 'package:atareak/views/components/password_field.dart';
import 'package:atareak/views/components/image_picker.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _idController = TextEditingController();

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _fatherNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  final UsersController _usersController = Get.put(UsersController());

  bool _smoker = false;

  bool _waiting = false;

  @override
  Widget build(BuildContext context) {
    final ProfileImagePicker _imageProfilePicker = ProfileImagePicker();
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          _imageProfilePicker,
          const SizedBox(height: 20),
          //
          const Text('المعلومات الشخصية', style: kTextLabelStyle),
          const SizedBox(height: 10),
          //
          idField(_idController),
          const SizedBox(height: 10),
          //
          textField(
            title: 'الاسم الأول',
            hintText: 'يجب أن تتطابق المعلومات مع الهوية الشخصية',
            controller: _firstNameController,
          ),
          const SizedBox(height: 10),
          //
          textField(
            title: 'الاسم الأخير',
            hintText: 'يجب أن تتطابق المعلومات مع الهوية الشخصية',
            controller: _lastNameController,
          ),
          const SizedBox(height: 10),
          //
          textField(
            title: 'اسم الأب',
            hintText: 'يجب أن تتطابق المعلومات مع الهوية الشخصية',
            controller: _fatherNameController,
          ),
          const SizedBox(height: 10),
          //
          stringField(
            label: 'كيف تصف نفسك',
            controller: _descriptionController,
          ),
          //
          smokeCheckBox(
            smoker: _smoker,
            onChange: (value) {
              setState(() => _smoker = value);
            },
          ),
          const SizedBox(height: 10),
          //
          const Text('معلومات التواصل', style: kTextLabelStyle),
          const SizedBox(height: 10),
          //
          emailField(_emailController),
          const SizedBox(height: 10),
          //
          phoneField(_phoneController),
          const SizedBox(height: 10),
          //
          const Text('كلمة المرور', style: kTextLabelStyle),
          const SizedBox(height: 10),
          PasswordField(
            labelText: 'كلمة المرور',
            controller: _passwordController,
            onChange: (strength) {
              setState(() => debugPrint(strength.toString()));
            },
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FlutterPasswordStrength(
              password: _passwordController.text,
            ),
          ),
          const SizedBox(height: 15),
          //
          passwordConfirmField(
              password: _passwordController.text,
              controller: _confirmPasswordController),
          const SizedBox(height: 10),

          _waiting ? const SizedBox(height: 10) : const SizedBox(height: 0),

          _waiting
              ? spinKitDoubleBounce()
              : ButtonPrimaryButton(
                  title: 'تسجيل حساب',
                  color: kColorPrimary,
                  minWidth: 350,
                  hight: 42,
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() => _waiting = true);
                    if (_formKey.currentState.validate()) {
                      final dynamic result = await _usersController.register(
                          id: _idController.text,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          fatherName: _fatherNameController.text,
                          description: _descriptionController.text,
                          smoker: _smoker,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          password: _passwordController.text,
                          imagePath: _imageProfilePicker.getImagePath());
                      if (result == true) {
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
                    Get.back();
                  },
                  child: const Text('لديك حساب بالفعل؟ سجل دخولك هنا'),
                ),
        ],
      ),
    );
  }
}
