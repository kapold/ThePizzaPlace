import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/AppColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Address.dart';
import '../models/Order.dart';
import '../models/OrderItem.dart';
import '../models/Pizza.dart';
import '../models/User.dart';

class Utils {
  static User? currentUser = null;
  static late List<Address> userAddresses;
  static late List<Pizza> pizzas;
  static late List<Order> history;
  static late List<OrderItem> historyItems;

  static CupertinoAlertDialog showAlertDialog(BuildContext context, String message) {
    Widget okButton = CupertinoDialogAction(
      child: Text("OK", style: TextStyle(color: AppColor.pumpkin)),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Внимание"),
      content: Text(message, style: TextStyle(fontSize: 16)),
      actions: [
        okButton,
      ],
    );

    showCupertinoDialog(
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

  static Future<bool> saveUserInSP(String username, String password, int role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setInt('role', role);
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

  static Future<int?> getRoleFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('role');
  }
}