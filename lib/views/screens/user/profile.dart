import 'package:atareak/controllers/internet_connection_controller.dart';
import 'package:atareak/controllers/users_controller.dart';
import 'package:atareak/controllers/utilities/const_information.dart';
import 'package:atareak/controllers/utilities/pref_keys.dart';
import 'package:atareak/models/user.dart';
import 'package:atareak/views/components/list_tile.dart';
import 'package:atareak/views/screens/user/rate.dart';
import 'package:atareak/views/screens/welcome.dart';
import 'package:atareak/views/utilities/assets_strings.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:atareak/views/utilities/buttons_styles.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/screens_ides.dart';
import 'package:atareak/views/components/bottom_navigation_bar.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  String userId;
  final int screenId;
  final bool ratable;

  Profile({this.userId, this.screenId, this.ratable = false});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool myProfile = false;

  final UsersController _usersController = Get.put(UsersController());

  final InternetConnectionController _internetConnectionController =
      Get.put(InternetConnectionController());

  Future<bool> internetConnection() async =>
      _internetConnectionController.checkInternetConnection();

  Future<User> _getUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String currentUserId = prefs.getString(PrefKeys.userID);
    if (widget.screenId == ScreenIdes.profileId ||
        widget.userId == currentUserId) {
      myProfile = true;
      widget.userId = currentUserId;
    }
    if (myProfile) {
      if (!await _internetConnectionController.checkInternetConnection()) {
        return User(
          id: prefs.getString(PrefKeys.userID),
          name: prefs.getString(PrefKeys.userName),
          gender: prefs.getString(PrefKeys.userGender),
          phone: prefs.getInt(PrefKeys.userPhone),
          age: prefs.getInt(PrefKeys.userAge),
          description: prefs.getString(PrefKeys.userDescription),
          smoker: prefs.getBool(PrefKeys.userSmoker),
        );
      }
    }

    return _usersController.getAUserProfile(id: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kColorPrimary,
        body: SafeArea(
          child: FutureBuilder(
              future: internetConnection(),
              builder: (context, projectSnap) {
                if (!projectSnap.data &&
                    widget.screenId != ScreenIdes.profileId) {
                  return Container(
                    color: kColorWhite,
                    child: const Center(
                      child: Text(
                        'لا يوجد إتصال بالإنترنت',
                        style: kTextLabelStyle,
                      ),
                    ),
                  );
                }
                return FutureBuilder(
                  future: _getUserProfile(),
                  builder: (context, projectSnap) {
                    if (projectSnap.connectionState == ConnectionState.none &&
                        projectSnap.hasData == null) {
                      return Container(
                        color: kColorWhite,
                        child: const Center(
                          child: Text('عذراً لقد حدث خطأ ما'),
                        ),
                      );
                    }
                    return projectSnap.data == null
                        ? Container(
                            color: kColorWhite,
                            child: const Center(
                              child: SpinKitDoubleBounce(color: kColorPrimary),
                            ),
                          )
                        : ProfileDesign(
                            myProfile: myProfile,
                            user: projectSnap.data,
                            screenId: widget.screenId,
                            ratable: widget.ratable,
                          );
                  },
                );
              }),
        ),
        bottomNavigationBar:
            MyBottomNavigationBar(screenIndex: widget.screenId),
      ),
    );
  }
}

class ProfileDesign extends StatelessWidget {
  final bool myProfile;
  final User user;
  final int screenId;
  final bool ratable;

  ProfileDesign({this.myProfile, this.user, this.screenId, this.ratable});

  final UsersController _usersController = Get.put(UsersController());

  @override
  Widget build(BuildContext context) {
    final List<Widget> _comments = [];
    if (user.comments == null) {
      _comments.add(
        const Text(
          'لا يوجد إتصال بالانترنت لتحميل آراء المستخدمين الخاصة بك',
          style: kTextNeutralStyle,
        ),
      );
    } else if (user.comments.isEmpty) {
      _comments.add(
        const Text(
          'لم يتم تقييم هذا المستخدم بعد',
          style: kTextNeutralStyle,
        ),
      );
    } else {
      for (final String comment in user.comments) {
        _comments.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment,
                style: kTextNeutralStyle,
              ),
              const Divider(),
            ],
          ),
        );
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: user.image == null
                    ? const AssetImage(kImageUser)
                    : NetworkImage(user.image),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: kTextWhiteBoldStyle),
                  const SizedBox(height: 10),
                  MyListTile(
                    leading: const Icon(
                      Icons.phone,
                      color: kColorWhite,
                      size: 15,
                    ),
                    primary:
                        Text('0${user.phone}', style: kTextMaterialButtonStyle),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VerticalListTile(
                leading: Text(user.gender, style: kTextWhiteBoldStyle),
                last: const Text('الجنس', style: kTextMaterialButtonStyle),
              ),
              VerticalListTile(
                leading: Text(user.age.toString(), style: kTextWhiteBoldStyle),
                last: const Text('العمر', style: kTextMaterialButtonStyle),
              ),
              VerticalListTile(
                leading: user.rating == null
                    ? const Text('...', style: kTextWhiteBoldStyle)
                    : Text('${user.rating.round()}%',
                        style: kTextWhiteBoldStyle),
                last: const Text('التقييم', style: kTextMaterialButtonStyle),
              ),
              myProfile
                  ? OutlinedButton(
                      style: outilnedWhiteButtonStyle,
                      onPressed: () {
                        _usersController.logout();
                        Get.offAll(() => Welcome());
                      },
                      child: const Text(
                        'تسجيل الخروج',
                        style: kTextMaterialButtonStyle,
                      ),
                    )
                  : ratable
                      ? OutlinedButton(
                          style: outilnedWhiteButtonStyle,
                          onPressed: () async {
                            final result = await Get.bottomSheet(RateAUSer(
                              id: user.id,
                            ));
                            if (result == true) {
                              Get.back();
                              Get.off(() => Profile(
                                    userId: user.id,
                                    screenId: screenId,
                                    ratable: ratable,
                                  ));
                            }
                          },
                          child: const Text(
                            'تقييم المستخدم',
                            style: kTextMaterialButtonStyle,
                          ),
                        )
                      : const SizedBox(),
            ],
          ),
        ),
        user.rating != null && user.rating < kWarningPercentage
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'انتبه تقييمك منخفض جداً، سوف يتم حظرك من النظام إن نقص تقييمك عن $kBlockPercentage%',
                  style: kTextWarningStyle,
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            decoration: kBoxDecorationStackedContainerWhite,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const Text('الوصف الشخصي:', style: kTextLabelStyle),
                  const SizedBox(height: 10),
                  Text(user.smoker ? '- مدخن' : '- غير مدخن',
                      style: kTextNeutralStyle),
                  user.description.isNotEmpty
                      ? Text('- ${user.description}', style: kTextNeutralStyle)
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  const Text('آراء المستخدمين:', style: kTextLabelStyle),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _comments,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
