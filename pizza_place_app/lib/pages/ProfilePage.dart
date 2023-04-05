import 'package:flutter/material.dart';
import 'package:pizza_place_app/models/User.dart';
import 'package:pizza_place_app/utils/AppColor.dart';
import 'package:pizza_place_app/utils/DbHandler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    DbHandler.fetchUsers().then((data) {
      setState(() {
        users = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Доброе утро!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                TextButton(
                    onPressed: () {
                      print(users[0].toString());
                    },
                    child: Text(
                      'Сохранить',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColor.notAvailable,
                    padding: EdgeInsets.all(16)
                  )
                )
              ]
            ),
          ),
          SizedBox(height: 32),
          Container(
            padding: EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: Icon(Icons.accessibility),
                    hintText: "Имя"
                  )
                ),
                SizedBox(height: 24),
                TextField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: Icon(Icons.phone),
                        hintText: "Телефон"
                    )
                ),
                SizedBox(height: 24),
                TextField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: Icon(Icons.email),
                        hintText: "Почта"
                    )
                ),
                SizedBox(height: 24),
                TextField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: Icon(Icons.date_range),
                        hintText: "День рождения"
                    )
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}