import 'package:atareak/controllers/notifications_controller.dart';
import 'package:atareak/controllers/utilities/global_variables.dart';
import 'package:atareak/models/Notification.dart' as noti;
import 'package:atareak/views/screens/welcome.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const notificationTask = "notificationTask";

Future<void> showNotification(int id, noti.Notification notification,
    FlutterLocalNotificationsPlugin localNotification) async {
  const android = AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.high, importance: Importance.max);
  const iOS = IOSNotificationDetails();
  const platform = NotificationDetails(android: android, iOS: iOS);
  await localNotification.show(
    id,
    'عَ طريقك',
    '${notification.title}\n${notification.message}',
    platform,
  );
}

void callbackDispatcher() {
  final Workmanager workmanager = Get.put(Workmanager());
  workmanager.executeTask(
    (task, inputData) async {
      final NotificationsController notificationsController =
          Get.put(NotificationsController());

      final FlutterLocalNotificationsPlugin localNotification =
          FlutterLocalNotificationsPlugin();
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iOS = IOSInitializationSettings();
      const initSetttings = InitializationSettings(android: android, iOS: iOS);
      localNotification.initialize(initSetttings);

      final notifications =
          await notificationsController.getUserNotifications(page: 1);
      if (notifications != null) {
        globalNotifications = notifications;
      }
      int notificationId = 0;
      for (final noti.Notification notification in notifications) {
        if (!notification.received) {
          showNotification(notificationId, notification, localNotification);
          notificationId++;
        }
      }
      return Future.value(true);
    },
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Workmanager workmanager = Get.put(Workmanager());
  await workmanager.initialize(
    callbackDispatcher,
  );
  await workmanager.registerPeriodicTask(
    'Atareak',
    notificationTask,
    existingWorkPolicy: ExistingWorkPolicy.replace,
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(seconds: 1),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Tajawal',
        accentColor: kColorPrimary,
        colorScheme: const ColorScheme.light(
          primary: kColorPrimary,
          secondary: kColorPrimary,
          error: kColorDanger,
        ),
      ),
      home: Welcome(),
    );
  }
}
