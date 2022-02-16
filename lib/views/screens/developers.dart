import 'package:atareak/views/components/app_bar.dart';
import 'package:atareak/views/components/page_selector.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';

class Developers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<DeveloperCard> developersCards = [
      const DeveloperCard(
        name: 'راما الطيب',
        discription: 'مطورة تطبيق الهاتف',
        email: 'ramaaltayeb26@gmail.com',
      ),
      const DeveloperCard(
        name: 'عمار السقال',
        discription: 'مطور المخدم قسم تطبيق الهاتف',
        email: 'a.suqqal@yahoo.com',
      ),
      const DeveloperCard(
        name: 'ريم رباح',
        discription: 'مطورة المخدم قسم تطبيق الويب',
        email: 'reemrabah.r5@gmail.com',
      ),
      const DeveloperCard(
        name: 'راما سليمان',
        discription: 'مطورة تطبيق الويب',
        email: 'ramaramosh91@gmail.com',
      )
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: myAppBar(title: 'فريق المطورين'),
        body: SafeArea(
          child: PageSelector(children: developersCards),
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String discription;
  final String email;

  const DeveloperCard({this.name, this.discription, this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: AssetImage('assets/images/developers/$name.jpg'),
        ),
        const SizedBox(height: 15),
        Text(name, style: kTextHeaddingStyle),
        const SizedBox(height: 10),
        Text(
          discription,
          style: kTextNeutralStyle,
        ),
        const SizedBox(height: 10),
        Text(
          email,
          style: kTextNeutralStyle,
        ),
      ],
    );
  }
}
