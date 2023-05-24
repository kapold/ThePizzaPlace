import 'package:flutter/material.dart';
import 'package:pizza_place_app/pages/AuthPage.dart';
import 'package:pizza_place_app/widgets/OrdersListView.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/AppColor.dart';
import '../utils/DbHandler.dart';
import '../utils/Utils.dart';

class DeliveryManPage extends StatefulWidget {
  const DeliveryManPage({Key? key}) : super(key: key);

  @override
  State<DeliveryManPage> createState() => _DeliveryManPageState();
}

class _DeliveryManPageState extends State<DeliveryManPage> {
  bool isShowable = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? usernameSP = await prefs.getString('username');
    String? passwordSP = await prefs.getString('password');
    if (usernameSP != "" && passwordSP != "") {
      print("! Preferences loaded ! -> name: ${usernameSP}, password: ${passwordSP}");
      _loadUser(usernameSP!, passwordSP!);
    }
  }

  Future<void> _loadUser(String username, String password) async {
    Utils.currentUser = await DbHandler.login(username, password, context);
    print(Utils.currentUser);
    if (Utils.currentUser != null) {
      Utils.userAddresses = await DbHandler.getUserAddresses(Utils.currentUser?.id, context);
    } else {
      Utils.userAddresses = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Доставка"),
            centerTitle: true
        ),
        body: Column(
          children: [
            Expanded(
              child: isShowable ? OrdersListView() : OrdersListView()
            ),
            Divider(color: Colors.black),
            SizedBox(height: 10),
            Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthPage()));
                      Utils.saveUserInSP("", "", 0);
                    },
                    child: Text("Выйти", style: TextStyle(color: Colors.white, fontSize: 20)),
                    style: TextButton.styleFrom(
                        backgroundColor: AppColor.pumpkin,
                        padding: EdgeInsets.only(top: 14, bottom: 14, right: 110, left: 110)
                    )
                )
            ),
            SizedBox(height: 20)
          ]
        )
    );
  }
}