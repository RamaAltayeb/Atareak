import 'package:atareak/controllers/utilities/global_variables.dart';
import 'package:atareak/controllers/utilities/pref_keys.dart';
import 'package:atareak/views/components/badges.dart';
import 'package:atareak/views/components/snackbars.dart';
import 'package:atareak/views/screens/cars/cars_list.dart';
import 'package:atareak/views/screens/maps/symbols_map.dart';
import 'package:atareak/views/screens/notifications/notifications_list.dart';
import 'package:atareak/views/screens/reservations/reservations_list.dart';
import 'package:atareak/views/screens/trips/trips_list.dart';
import 'package:atareak/views/screens/user/profile.dart';
import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int screenIndex;
  const MyBottomNavigationBar({this.screenIndex});
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  static final List<dynamic> _screens = [
    const SymbolsMap(),
    TripsList(),
    CarsList(),
    ReservationsList(),
    NotificationsList(),
    Profile(screenId: ScreenIdes.profileId),
  ];

  bool _roleIsValid = false;

  @override
  void initState() {
    super.initState();
    _setStateBools();
  }

  Future<void> _setStateBools() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _roleIsValid = prefs.getStringList(PrefKeys.userRoles).contains('Adult');
    });
  }

  void _onItemTaped(int index) {
    if (!_roleIsValid &&
        (index == ScreenIdes.tripsScreenId ||
            index == ScreenIdes.carsScreenId)) {
      mySnackbar(title: 'عذراً أنت تحت السن القانوني لقيادة السيارات');
    } else {
      Get.until((route) => route.isFirst);
      if (index == ScreenIdes.notificationsScreenId) {
        newReceivedNotifications = 0.obs;
      }
      if (index != ScreenIdes.symbolsScreenId) {
        Get.to(_screens[index]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.map_rounded),
          label: 'خريطتي',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.emoji_transportation_rounded),
          label: 'رحلاتي',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.drive_eta_rounded),
          label: 'سياراتي',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chrome_reader_mode),
          label: 'حجوزاتي',
        ),
        BottomNavigationBarItem(
          icon: Obx(
            () => Stack(
              children: [
                const Icon(Icons.notifications_rounded),
                newReceivedNotifications != 0.obs
                    ? NotificationsBadge()
                    : const SizedBox(),
              ],
            ),
          ),
          label: 'إشعاراتي',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'حسابي',
        ),
      ],
      currentIndex: widget.screenIndex,
      selectedItemColor: kColorPrimary,
      unselectedItemColor: kColorSecondary,
      onTap: _onItemTaped,
    );
  }
}
