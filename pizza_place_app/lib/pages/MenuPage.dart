import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_place_app/utils/AppColor.dart';
import 'package:pizza_place_app/utils/CustomSearchDelegate.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late String _timeString;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }

  void _getCurrentTime() {
    if (mounted) {
      setState(() {
        _timeString = _formatDateTime(DateTime.now());
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: Colors.transparent,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: Row(
                    children: [
                      Text(
                        _timeString,
                        style: TextStyle(color: Colors.black),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Image.asset("assets/icons/clock.png", width: 16, height: 16)
                    ],
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.pumpkin,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 16)),
                IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: CustomSearchDelegate()
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
                Padding(padding: EdgeInsets.only(left: 16))
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Container(
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              'Выгодно и вкусно',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            )
          ),
          Padding(padding: EdgeInsets.all(10)),
          // TODO: LIST
        ],
      ),
    );
  }
}