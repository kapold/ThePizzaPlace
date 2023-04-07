import 'package:flutter/material.dart';
import 'package:pizza_place_app/models/User.dart';
import 'package:pizza_place_app/utils/DbHandler.dart';

import '../utils/AppColor.dart';
import '../utils/Utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final repeatPasswordCtrl = TextEditingController();
  String username = "", password = "", repeatPassword = "";

  bool checkCredentials() {
    if (username.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      Utils.showAlertDialog(context, "Заполните все поля!");
      return false;
    }
    if (username.length < 4 || password.length < 8) {
      Utils.showAlertDialog(context, "Проверьте данные: имя не менее 4 символов, пароль не менее 8 символов!");
      return false;
    }
    if (password != repeatPassword) {
      Utils.showAlertDialog(context, "Пароли не совпадают!");
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    usernameCtrl.addListener(updateTextValue);
    passwordCtrl.addListener(updateTextValue);
    repeatPasswordCtrl.addListener(updateTextValue);
  }

  void updateTextValue() {
    setState(() {
      username = usernameCtrl.text;
      password = passwordCtrl.text;
      repeatPassword = repeatPasswordCtrl.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(left: 32, right: 32, top: 100, bottom: 16),
            child: Column(
                children: [
                  Icon(
                    Icons.supervised_user_circle,
                    size: 128,
                    color: Colors.deepOrange,
                  ),
                  SizedBox(height: 48),
                  TextField(
                      controller: usernameCtrl,
                      maxLength: 16,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          prefixIcon: Container(
                              child: Icon(Icons.accessibility),
                              padding: EdgeInsets.only(left: 16, right: 16)
                          ),
                          hintText: "Имя пользователя"
                      )
                  ),
                  SizedBox(height: 12),
                  TextField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: Container(
                            child: Icon(Icons.password),
                            padding: EdgeInsets.only(left: 16, right: 16)
                        ),
                        hintText: "Пароль",
                      )
                  ),
                  SizedBox(height: 32),
                  TextField(
                      controller: repeatPasswordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: Container(
                            child: Icon(Icons.password_outlined),
                            padding: EdgeInsets.only(left: 16, right: 16)
                        ),
                        hintText: "Повторите пароль",
                      )
                  ),
                  SizedBox(height: 64),
                  TextButton(
                      onPressed: () async {
                        if (!checkCredentials())
                          return;
                        bool result = await DbHandler.addUser(new User(username: username, password: password), context);
                        if (result) {
                          Navigator.pushNamed(context, '/auth');
                          Utils.showAlertDialog(context, "Успешно");
                        }
                      },
                      child: Text(
                        'Создать',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: AppColor.pumpkin,
                          padding: EdgeInsets.only(top: 20, bottom: 20, right: 128, left: 128)
                      )
                  ),
                  SizedBox(height: 16),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/auth");
                      },
                      child: Text(
                        'Уже с нами',
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
                ]
            )
        )
    );
  }
}