import 'package:atareak/controllers/utilities/global_variables.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:flutter/material.dart';

class NotificationsBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 7,
      backgroundColor: kColorDanger,
      child: Text(
         newReceivedNotifications.toString(),
        style: const TextStyle(color: kColorWhite, fontSize: 14),
      ),
    );
  }
}
