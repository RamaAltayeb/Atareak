import 'package:atareak/views/utilities/transformers.dart';
import 'package:atareak/models/map_route.dart';
import 'package:atareak/views/components/list_tile.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:atareak/views/utilities/buttons_styles.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';

class RouteCard extends StatelessWidget {
  final MapRoute mapRoute;
  final Function onButtonPressed;

  const RouteCard({this.mapRoute, this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: kBoxDecorationCardWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 2),
          MyListTile(
            leading: const Icon(Icons.traffic_rounded, color: kColorPrimary),
            primary: Text(
              mapRoute.status,
              style: kTextPrimaryStyle,
            ),
          ),
          Row(
            children: [
              MyListTile(
                leading: const Icon(Icons.linear_scale_rounded,
                    color: kColorNeutral),
                primary: Text(
                  distanceTransform(mapRoute.json['distance']),
                  style: kTextNeutralStyle,
                ),
              ),
              const SizedBox(width: 30),
              MyListTile(
                leading: const Icon(Icons.timer_rounded, color: kColorNeutral),
                primary: Text(
                  durationTransform(mapRoute.json['duration']),
                  style: kTextNeutralStyle,
                ),
              ),
            ],
          ),
          MaterialButton(
            color: kColorPrimary,
            shape: materialButtonShape,
            onPressed: onButtonPressed,
            child: const Text(
              'اختر هذا الطريق',
              style: kTextMaterialButtonStyle,
            ),
          ),
        ],
      ),
    );
  }
}
