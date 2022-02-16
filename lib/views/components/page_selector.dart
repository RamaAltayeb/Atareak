import 'package:flutter/material.dart';

class PageSelector extends StatelessWidget {
  final List<Widget> children;

  const PageSelector({this.children});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: children.length,
      child: Builder(
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: TabBarView(children: children),
              ),
              const TabPageSelector(),
            ],
          ),
        ),
      ),
    );
  }
}
