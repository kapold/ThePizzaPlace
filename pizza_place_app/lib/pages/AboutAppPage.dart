import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/AppColor.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: AppColor.pumpkin,
      ),
      body: Container(
        margin: EdgeInsets.all(32),
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: AppColor.pumpkin,
                style: BorderStyle.solid), //Border.all
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Text('Разработано: Адамович АМ')
      ),
    );
  }
}