import 'package:atareak/views/components/list_tile.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';

Widget pickPointListTile({String name, double width}) {
  return MyListTile(
    leading: const Icon(Icons.location_on, color: kColorNeutral, size: 20),
    primary: Container(
      width: width,
      child: Flexible(
        child: Text(
          'نقطة الصعود: $name',
          style: kTextNeutralStyleSmaller,
          overflow: TextOverflow.fade,
          softWrap: true,
        ),
      ),
    ),
  );
}

Widget dropPointListTile({String name, double width}) {
  return MyListTile(
    leading: const Icon(Icons.location_on, color: kColorPrimary, size: 20),
    primary: Container(
      width: width,
      child: Flexible(
        child: Text(
          'نقطة النزول: $name',
          style: kTextPrimaryStyle.copyWith(fontSize: 16),
          overflow: TextOverflow.fade,
          softWrap: true,
        ),
      ),
    ),
  );
}

Widget reservationSeatsListTile(int seats) {
  return MyListTile(
    leading: const Icon(Icons.airline_seat_recline_normal,
        color: kColorNeutral, size: 20),
    primary: Text(
      'عدد المقاعد المطلوبة: $seats',
      style: kTextNeutralStyleSmaller,
    ),
  );
}
