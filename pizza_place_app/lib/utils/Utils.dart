import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/AppColor.dart';

class Utils {
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
}