import 'package:flutter/material.dart';

class DateTimeController {
  static DateTime toDateTime(String dateTimeString) =>
      DateTime.parse(dateTimeString);

  static String dateTimeToString(DateTime dateTime) =>
      '${dateTime.toString().substring(0, 10)}T${dateTime.toString().substring(11, 16)}';

  static String dateTimeToDisplayString(DateTime dateTime) {
    final time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    final String period = time.period == DayPeriod.am ? 'ص' : 'م';
    return '${time.hourOfPeriod}:${time.minute} $period';
  }

  static String fullDateTimeToDisplayString(DateTime dateTime) {
    final time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    final String period = time.period == DayPeriod.am ? 'ص' : 'م';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} - ${time.hourOfPeriod}:${time.minute} $period';
  }
}
