import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/DbHandler.dart';
import '../utils/Utils.dart';

class DeliveryManPage extends StatefulWidget {
  const DeliveryManPage({Key? key}) : super(key: key);

  @override
  State<DeliveryManPage> createState() => _DeliveryManPageState();
}

class _DeliveryManPageState extends State<DeliveryManPage> {
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
            title: Text("${Utils.currentUser?.username}")
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(32),
              child: Text("dfgd")
            )
          ]
        )
    );
  }
}