import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final Widget leading;
  final Widget primary;
  final Widget secondary;
  const MyListTile({this.leading, this.primary, this.secondary});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            primary,
            secondary != null
                ? const SizedBox(height: 3)
                : const SizedBox(height: 0),
            secondary ?? const SizedBox(height: 0),
          ],
        ),
      ],
    );
  }
}

class VerticalListTile extends StatelessWidget {
  final Widget leading;
  final Widget last;
  const VerticalListTile({this.leading, this.last});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        leading,
        const SizedBox(height: 3),
        last,
      ],
    );
  }
}
