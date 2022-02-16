import 'package:atareak/views/components/list_tile.dart';
import 'package:atareak/views/screens/user/profile.dart';
import 'package:atareak/views/utilities/assets_strings.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget personListTiel({
  String name,
  String image,
  String id,
  int screenId,
  bool ratable = false,
}) {
  return GestureDetector(
    onTap: () => Get.to(Profile(
      userId: id,
      screenId: screenId,
      ratable: ratable,
    )),
    child: MyListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: image == null
            ? const AssetImage(kImageUser)
            : NetworkImage(image),
      ),
      primary: Text(
        name,
        style: kTextNeutralStyleSmaller,
      ),
    ),
  );
}
