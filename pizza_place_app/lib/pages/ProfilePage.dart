import 'package:flutter/material.dart';
import 'package:pizza_place_app/classes/AppColor.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 80,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello, ?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.settings, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shadowColor: AppColor.pumpkin,
                    fixedSize: const Size(60, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                    )
                  )
                )
              ],
            ),
          ),
          Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  color: Colors.red,
                  padding: EdgeInsets.all(80),
                ),
                Column(
                  children: [
                    Container(
                      height: 40,
                      color: Colors.green,
                      padding: EdgeInsets.all(80),
                    ),
                    Container(
                      height: 40,
                      color: Colors.purple,
                      padding: EdgeInsets.all(80),
                    )
                  ],
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}