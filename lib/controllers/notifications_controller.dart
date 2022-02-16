import 'dart:convert';

import 'package:atareak/models/Notification.dart' as noti;
import 'package:atareak/controllers/network_handler.dart';
import 'package:atareak/views/utilities/server_messages_translator.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  static final NetworkHandler _networkHandler = NetworkHandler();
  static String errorMessage = '';

  Future<List<noti.Notification>> getUserNotifications({int page}) async {
    final Map<String, dynamic> data = {'page': page.toString()};
    final response = await _networkHandler.get('/user/notification', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> output = jsonDecode(response.body);
      final List<noti.Notification> notifications = [];
      for (final dynamic notificationJson in output) {
        final noti.Notification notification =
            noti.Notification.fromJson(notificationJson);
        notifications.add(notification);
      }
      return notifications;
    }
    errorMessage = serverMessageTranslator(response.body);
    return null;
  }

  Future<void> markNotificationAsRead({String id}) async {
    await _networkHandler.get('/user/notification/$id');
  }
}
