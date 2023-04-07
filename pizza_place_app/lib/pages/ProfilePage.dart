import 'package:flutter/material.dart';
import 'package:pizza_place_app/models/User.dart';
import 'package:pizza_place_app/pages/AuthPage.dart';
import 'package:pizza_place_app/utils/AppColor.dart';
import 'package:pizza_place_app/utils/DbHandler.dart';

import '../utils/Utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final usernameCtrl = TextEditingController();
  final phoneNumberCtrl = TextEditingController();
  final birthdayCtrl = TextEditingController();
  bool isButtonEnabled = false;
  String username = "", phoneNumber = "", birthday = "";

  @override
  void initState() {
    super.initState();
    usernameCtrl.addListener(updateTextValue);
    phoneNumberCtrl.addListener(updateTextValue);
    birthdayCtrl.addListener(updateTextValue);
    setState(() {
      String u = Utils.currentUser!.username ?? "";
      String p = Utils.currentUser!.phoneNumber ?? "";
      String b = Utils.currentUser!.birthday != null ? Utils.currentUser!.birthday!.toString().substring(0, 10) : "";
      usernameCtrl.text = u;
      phoneNumberCtrl.text = p;
      birthdayCtrl.text = b;
    });
  }

  void updateTextValue() {
    setState(() {
      username = usernameCtrl.text;
      phoneNumber = phoneNumberCtrl.text;
      birthday = birthdayCtrl.text;

      String u = Utils.currentUser!.username ?? "";
      String p = Utils.currentUser!.phoneNumber ?? "";
      String b = Utils.currentUser!.birthday != null ? Utils.currentUser!.birthday!.toString().substring(0, 10) : "";
      if (usernameCtrl.text == u &&
          phoneNumberCtrl.text == p &&
          birthdayCtrl.text == b) {
        setState(() {
          isButtonEnabled = false;
        });
      }
      else {
        isButtonEnabled = true;
      }
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
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                  ),
                ),
                TextButton(
                    onPressed: isButtonEnabled ? () {
                      // TODO: saving user
                    } : null,
                    child: Text(
                      'Сохранить',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),
                    ),
                  style: TextButton.styleFrom(
                    backgroundColor: isButtonEnabled? AppColor.pumpkin : AppColor.notAvailable,
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
                  controller: usernameCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    prefixIcon: Container(
                      child: Icon(Icons.accessibility),
                      padding: EdgeInsets.only(left: 16, right: 16)
                    ),
                    hintText: "Имя"
                  )
                ),
                SizedBox(height: 24),
                TextField(
                    controller: phoneNumberCtrl,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: Container(
                            child: Icon(Icons.phone),
                            padding: EdgeInsets.only(left: 16, right: 16)
                        ),
                        hintText: "Телефон"
                    ),
                ),
                SizedBox(height: 24),
                TextField(
                    controller: birthdayCtrl,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: Container(
                            child: Icon(Icons.date_range),
                            padding: EdgeInsets.only(left: 16, right: 16)
                        ),
                        hintText: "День рождения",
                        helperText: "Формат даты: ГГГГ-ММ-ДД"
                    ),
                    maxLength: 10,
                ),
                SizedBox(height: 32),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthPage()));
                      Utils.saveUserInSP("", "");
                    },
                    child: Text(
                      'Выйти',
                      style: TextStyle(
                          color: AppColor.pumpkin,
                          fontSize: 18
                      ),
                    ),
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: AppColor.pumpkin)
                        ),
                        padding: EdgeInsets.only(top: 20, bottom: 20, right: 66, left: 66)
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