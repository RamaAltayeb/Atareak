import 'dart:convert';

import 'package:atareak/controllers/datetime_controller.dart';
import 'package:atareak/controllers/utilities/global_variables.dart';

class Notification {
  String id;
  String title;
  dynamic context;
  String userId;
  String message;
  DateTime createdAt;
  bool read;
  bool received;

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    context = jsonDecode(json['context']);
    userId = context['FromUser'];
    message = context['Context'];
    read = json['read'];
    received = json['received'];
    if (!received) {
      newReceivedNotifications++;
    }
    if (DateTime.now().month > 3 && DateTime.now().month < 11) {
      createdAt = DateTimeController.toDateTime(json['createdAt'])
          .add(const Duration(hours: 3));
    } else {
      createdAt = DateTimeController.toDateTime(json['createdAt'])
          .add(const Duration(hours: 2));
    }
  }
}

class NotificationTitle {
  static const String carShareRequest = 'مشاركة سيارة';
  static const String approveReservation = 'الانضمام لرحلة';
  static const String deleteTrip = 'حذف رحلة';
  static const String deleteReservation = 'إلغاء حجز';
  static const String warning = 'انذار';
}
