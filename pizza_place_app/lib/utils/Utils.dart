import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/AppColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Address.dart';
import '../models/User.dart';

class Utils {
  static User? currentUser = null;
  static late List<Address> userAddresses;

  static AlertDialog showAlertDialog(BuildContext context, String message) {
    Widget okButton = TextButton(
      child: Text("OK", style: TextStyle(color: AppColor.pumpkin)),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Внимание"),
      content: Text(message, style: TextStyle(fontSize: 16)),
      actions: [
        okButton,
      ]
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      }
    );
    return alert;
  }

  static void showListInfo(List list) {
    print("<----- List info ----->");
    for(var item in list)
      print(item.toString());
  }

  static Future<bool> saveUserInSP(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    return true;
  }

  static Future<String?> getUsernameFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<String?> getPasswordFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }
}