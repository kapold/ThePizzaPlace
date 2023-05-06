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
      try {
        String u = Utils.currentUser!.username ?? "";
        String p = Utils.currentUser!.phone_number ?? "";
        String b = Utils.currentUser!.birthday != null ? Utils.currentUser!.birthday!.toString().substring(0, 10) : "";
        usernameCtrl.text = u;
        phoneNumberCtrl.text = p;
        birthdayCtrl.text = b;
      }
      catch(e) {
        usernameCtrl.text = "";
        phoneNumberCtrl.text = "";
        birthdayCtrl.text = "";
        print(e);
      }
    });
  }

  void updateTextValue() {
    setState(() {
      username = usernameCtrl.text;
      phoneNumber = phoneNumberCtrl.text;
      birthday = birthdayCtrl.text;

      String u = Utils.currentUser!.username ?? "";
      String p = Utils.currentUser!.phone_number ?? "";
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(32),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Добрый день!',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthPage()));
                            Utils.saveUserInSP("", "", 0);
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
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(color: AppColor.pumpkin)
                              ),
                              padding: EdgeInsets.only(top: 14, bottom: 14, right: 40, left: 40)
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
                          onPressed: isButtonEnabled ? () async {
                            User? newUser = Utils.currentUser;
                            newUser?.phone_number = phoneNumber;
                            newUser?.birthday = birthday;
                            bool result = await DbHandler.updateUser(newUser!, context);
                            if (!result) {
                              Utils.showAlertDialog(context, 'Ошибка при сохранении данных');
                              return;
                            }
                            setState(() {
                              isButtonEnabled = false;
                            });
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
                              padding: EdgeInsets.only(top: 14, bottom: 14, right: 64, left: 64)
                          )
                      ),
                      SizedBox(height: 20),
                      TextButton(
                          onPressed: () async {
                            Utils.userAddresses = await DbHandler.getUserAddresses(Utils.currentUser?.id, context);
                            Navigator.pushNamed(context, '/addresses');
                          },
                          child: Text(
                            'Добавить адрес',
                            style: TextStyle(
                                color: AppColor.pumpkin,
                                fontSize: 18
                            ),
                          ),
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(color: AppColor.pumpkin)
                              ),
                              padding: EdgeInsets.only(top: 14, bottom: 14, right: 60, left: 60)
                          )
                      ),
                      SizedBox(height: 20),
                      TextButton(
                          onPressed: () async {
                            // TODO: history
                            Utils.history = [];
                            Navigator.pushNamed(context, '/history');
                          },
                          child: Text(
                            'История заказов',
                            style: TextStyle(
                                color: AppColor.pumpkin,
                                fontSize: 18
                            ),
                          ),
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(color: AppColor.pumpkin)
                              ),
                              padding: EdgeInsets.only(top: 14, bottom: 14, right: 58, left: 58)
                          )
                      )
                    ]
                ),
              )
            ]
        )
      )
    );
  }
}