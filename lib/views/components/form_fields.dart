import 'package:atareak/controllers/utilities/const_information.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_field_styles.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';

Widget idField(TextEditingController controller) {
  return TextFormField(
    keyboardType: TextInputType.number,
    controller: controller,
    maxLength: kIdStringLength,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'رجاءً أدخل المعلومات المطلوبة';
      } else if (value.length != kIdStringLength || !isPureNumber(value)) {
        return 'رجاءً أدخل رقماً وطنياً صالحاً';
      }
      return null;
    },
    decoration: kFormTextFieldsStyle.copyWith(labelText: 'الرقم الوطني'),
  );
}

//--------------------------------------------------------------------------//

Widget textField({
  String title,
  String hintText = '',
  TextEditingController controller,
}) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: controller,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'رجاءً أدخل المعلومات المطلوبة';
      }
      return null;
    },
    decoration:
        kFormTextFieldsStyle.copyWith(labelText: title, hintText: hintText),
  );
}

//--------------------------------------------------------------------------//

Widget stringField({
  String label,
  TextEditingController controller,
  bool validator = false,
}) {
  return TextFormField(
    keyboardType: TextInputType.multiline,
    controller: controller,
    validator: !validator
        ? null
        : (value) {
            if (value == null || value.isEmpty) {
              return 'رجاءً أدخل المعلومات المطلوبة';
            }
            return null;
          },
    decoration: kFormTextFieldsStyle.copyWith(
      labelText: label,
    ),
    maxLines: 3,
  );
}

//--------------------------------------------------------------------------//

Widget smokeCheckBox({bool smoker, Function onChange}) {
  return Row(
    children: [
      Checkbox(
        value: smoker,
        onChanged: onChange,
        checkColor: kColorWhite,
      ),
      const Text(
        'أنا مدخن',
        style: kTextNeutralStyle,
      ),
    ],
  );
}

//--------------------------------------------------------------------------//

Widget emailField(TextEditingController controller) {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    controller: controller,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'رجاءً أدخل المعلومات المطلوبة';
      } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
          .hasMatch(value)) {
        return 'رجاءً أدخل بريداَ إلكترونياً صالحاً';
      }
      return null;
    },
    decoration: kFormTextFieldsStyle.copyWith(labelText: 'البريد الإلكتروني'),
  );
}

//--------------------------------------------------------------------------//

Widget phoneField(TextEditingController controller) {
  return TextFormField(
    keyboardType: TextInputType.number,
    controller: controller,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'رجاءً أدخل المعلومات المطلوبة';
      } else if (value.length != kPhoneStringLength || !isPureNumber(value)) {
        return 'رجاءً أدخل رقماً صالحاً';
      }
      return null;
    },
    maxLength: kPhoneStringLength,
    decoration: kFormTextFieldsStyle.copyWith(
      labelText: 'الهاتف',
      suffixText: '9 963+',
    ),
  );
}

//--------------------------------------------------------------------------//

Widget doubleNumberField({
  String label,
  double maxValue,
  String hintText = '',
  bool autofocus = false,
  TextEditingController controller,
}) {
  return TextFormField(
    keyboardType: TextInputType.number,
    controller: controller,
    autofocus: autofocus,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'رجاءً أدخل المعلومات المطلوبة';
        // ignore: avoid_bool_literals_in_conditional_expressions
      } else if ((maxValue != null ? double.parse(value) > maxValue : false) ||
          !isDoubleNumber(value)) {
        return 'رجاءً أدخل قيمة صالحة';
      }
      return null;
    },
    decoration:
        kFormTextFieldsStyle.copyWith(labelText: label, hintText: hintText),
  );
}

//--------------------------------------------------------------------------//

Widget intNumberField(
    {String label,
    int minValue,
    int maxValue,
    int maxLength,
    String hintText = '',
    bool autofocus = false,
    TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.number,
    controller: controller,
    autofocus: autofocus,
    maxLength: maxLength,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'رجاءً أدخل المعلومات المطلوبة';
        // ignore: avoid_bool_literals_in_conditional_expressions
      } else if ((minValue != null ? int.parse(value) < minValue : false) ||
          // ignore: avoid_bool_literals_in_conditional_expressions
          (maxValue != null ? int.parse(value) > maxValue : false) ||
          !isPureNumber(value)) {
        return 'رجاءً أدخل قيمة صالحة';
      }
      return null;
    },
    decoration: kFormTextFieldsStyle.copyWith(
      labelText: label,
      hintText: hintText,
    ),
  );
}

//--------------------------------------------------------------------------//
Widget passwordConfirmField(
    {String password, TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: controller,
    obscureText: true,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'رجاءً أدخل المعلومات المطلوبة';
      } else if (value != password) {
        return 'كلمة المرور غير متطابقة';
      }
      return null;
    },
    decoration: kFormTextFieldsStyle.copyWith(labelText: 'تأكيد كلمة المرور'),
  );
}

//--------------------------------------------------------------------------//

bool isPureNumber(String number) {
  if (number.contains("-") ||
      number.contains(",") ||
      number.contains(".") ||
      number.contains(" ")) {
    return false;
  }
  return true;
}

//--------------------------------------------------------------------------//

bool isDoubleNumber(String number) {
  if (number.contains("-") || number.contains(",") || number.contains(" ")) {
    return false;
  }
  return true;
}
