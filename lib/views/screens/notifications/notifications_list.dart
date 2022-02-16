import 'package:atareak/controllers/internet_connection_controller.dart';
import 'package:atareak/controllers/notifications_controller.dart';
import 'package:atareak/controllers/utilities/global_variables.dart';
import 'package:atareak/views/components/bottom_navigation_bar.dart';
import 'package:atareak/views/components/dismissible_tile.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/models/Notification.dart' as noti;
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class NotificationsList extends StatefulWidget {
  @override
  _NotificationsListState createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  final List<int> _pagesNumbers = [1];

  int _nextPage = 2;

  bool _lazyListIsLoading = false;

  bool _reachedTheEnd = false;

  bool _firstFetch = true;

  final NotificationsController _notificationsController =
      Get.put(NotificationsController());

  final InternetConnectionController _internetConnectionController =
      Get.put(InternetConnectionController());

  final ScrollController _scrollController = ScrollController();

  Future<bool> _internetConnection() async =>
      _internetConnectionController.checkInternetConnection();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    newReceivedNotifications = 0.obs;
  }

  Future<void> _onScroll() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_reachedTheEnd) {
      setState(() {
        _lazyListIsLoading = true;
      });
      await _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (!_pagesNumbers.contains(_nextPage)) {
      _pagesNumbers.add(_nextPage);
      final List<noti.Notification> pageNotifications =
          await _notificationsController.getUserNotifications(page: _nextPage);
      newReceivedNotifications = 0.obs;
      _nextPage++;
      setState(() {
        pageNotifications.isEmpty
            ? _reachedTheEnd = true
            : globalNotifications.addAll(pageNotifications);
        _lazyListIsLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    final result = await _notificationsController.getUserNotifications(page: 1);
    newReceivedNotifications = 0.obs;
    setState(() {
      if (result != null) {
        globalNotifications = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future: _internetConnection(),
            builder: (context, projectSnap) {
              if (!projectSnap.data && globalNotifications.isEmpty) {
                return const Center(
                  child:
                      Text('لا يوجد إتصال بالإنترنت', style: kTextLabelStyle),
                );
              }
              if (_firstFetch) {
                _refresh();
              }
              _firstFetch = false;
              return Expanded(child: _notificationsWidget());
            },
          ),
        ),
        bottomNavigationBar: const MyBottomNavigationBar(
          screenIndex: ScreenIdes.notificationsScreenId,
        ),
      ),
    );
  }

  Widget _notificationsWidget() {
    if (globalNotifications.isEmpty) {
      return const Center(
        child: Text('ليس لديك إشعارات', style: kTextLabelStyle),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: _lazyListIsLoading
          ? globalNotifications.length + 1
          : globalNotifications.length,
      itemBuilder: (context, index) {
        if (globalNotifications.length == index) {
          return Container(
            height: 100,
            child: const Center(
              child: SpinKitDoubleBounce(color: kColorPrimary),
            ),
          );
        }
        return DismissibleNotificationTile(
            notification: globalNotifications[index]);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
