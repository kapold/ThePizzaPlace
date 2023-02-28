import 'package:flutter/material.dart';
import 'package:pizza_place_app/classes/AppColor.dart';
import 'package:pizza_place_app/classes/CustomSearchDelegate.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
                        '8888',
                        style: TextStyle(color: Colors.black),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Image.asset("assets/icons/coins.png", width: 16, height: 16)
                    ],
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.pumpkin
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: CustomSearchDelegate()
                    );
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey
            ),
            height: 140,
            width: 1000,
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Column(
                children: [
                  // TODO: Switch
                ]
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