import 'package:atareak/models/car.dart';
import 'package:atareak/models/user.dart';
import 'package:atareak/views/screens/user/profile.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'list_tile.dart';

Widget launchPointListTile({String name, double width}) {
  if (name == '') {
    name = 'اسم المنطقة غير متوفر';
  }
  return MyListTile(
    leading: const Icon(Icons.location_on, color: kColorNeutral),
    primary: Container(
      width: width,
      child: Flexible(
        child: Text(
          'نقطة الإنطللاق: $name',
          style: kTextNeutralStyleSmaller,
          overflow: TextOverflow.fade,
          softWrap: true,
        ),
      ),
    ),
  );
}

Widget destinationListTile({String name, double width}) {
  if (name == '') {
    name = 'اسم المنطقة غير متوفر';
  }
  return MyListTile(
    leading: const Icon(Icons.location_on, color: kColorPrimary),
    primary: Container(
      width: width,
      child: Flexible(
        child: Text(
          'الوجهة: $name',
          style: kTextPrimaryStyle.copyWith(fontSize: 16),
          overflow: TextOverflow.fade,
          softWrap: true,
        ),
      ),
    ),
  );
}

Widget distanceListTile(String text) {
  return MyListTile(
    leading:
        const Icon(Icons.linear_scale_rounded, color: kColorNeutral, size: 20),
    primary: Text(
      'المسافة: $text',
      style: kTextNeutralStyleSmaller,
    ),
  );
}

Widget launchTimeListTile(String text) {
  return MyListTile(
    leading:
        const Icon(Icons.access_time_rounded, color: kColorNeutral, size: 20),
    primary: Text(
      'وقت الإنطلاق: $text',
      style: kTextNeutralStyleSmaller,
    ),
  );
}

Widget durationListTile(String text) {
  return MyListTile(
    leading: const Icon(Icons.timer_rounded, color: kColorNeutral, size: 20),
    primary: Text(
      'مدة الرحلة: $text',
      style: kTextNeutralStyleSmaller,
    ),
  );
}

Widget totalSeatsNumListTile(String text) {
  return MyListTile(
    leading: const Icon(Icons.airline_seat_recline_normal,
        color: kColorNeutral, size: 20),
    primary: Text(
      'عدد المقاعد الكلي: $text',
      style: kTextNeutralStyleSmaller,
    ),
  );
}

Widget availableSeatsNumListTile(String text) {
  return MyListTile(
    leading: const Icon(Icons.airline_seat_recline_normal,
        color: kColorNeutral, size: 20),
    primary: Text(
      'عدد المقاعد الفارغة: $text',
      style: kTextNeutralStyleSmaller,
    ),
  );
}

Widget totalPriceListTile(String text) {
  return MyListTile(
    leading: const Icon(Icons.money_rounded, color: kColorNeutral, size: 20),
    primary: Text(
      'ثمن الرحلة: $text',
      style: kTextNeutralStyleSmaller,
    ),
  );
}

Widget seatPriceListTile(String text) {
  return MyListTile(
    leading: const Icon(Icons.money_rounded, color: kColorNeutral, size: 20),
    primary: Text(
      'ثمن المقعد: $text',
      style: kTextNeutralStyleSmaller,
    ),
  );
}

Widget carListTile(Car car) {
  return MyListTile(
    leading:
        const Icon(Icons.drive_eta_rounded, color: kColorNeutral, size: 20),
    primary: Text(
      'السيارة: ${car.model} (${car.id})',
      style: kTextNeutralStyleSmaller,
    ),
  );
}

Widget driverListTile(
    {String text, String id, int screenId, bool ratable = false}) {
  return GestureDetector(
    onTap: () => Get.to(Profile(
      userId: id,
      screenId: screenId,
      ratable: ratable,
    )),
    child: MyListTile(
      leading: const Icon(Icons.person, color: kColorNeutral, size: 20),
      primary: Text(
        'اسم السائق: $text',
        style: kTextNeutralStyleSmaller,
      ),
    ),
  );
}

Widget clientListTile({Client client, int screenId, bool ratable = false}) {
  return GestureDetector(
    onTap: () => Get.to(Profile(
      userId: client.id,
      screenId: screenId,
      ratable: ratable,
    )),
    child: MyListTile(
      leading: const Icon(Icons.person, color: kColorNeutral, size: 20),
      primary: Row(
        children: [
          Text('${client.name}، ', style: kTextNeutralStyleSmaller),
          const SizedBox(width: 5),
          Text('${client.seats} مقعد', style: kTextNeutralStyleSmallest),
        ],
      ),
    ),
  );
}
