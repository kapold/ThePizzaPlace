import 'package:flutter/material.dart';
import 'package:pizza_place_app/pages/AdminPage.dart';
import 'package:pizza_place_app/pages/DeliveryManPage.dart';
import 'package:pizza_place_app/pages/MainPage.dart';
import 'package:pizza_place_app/utils/DbHandler.dart';
import 'package:pizza_place_app/utils/Utils.dart';

import '../models/User.dart';
import '../utils/AppColor.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String username = "", password = "";

  @override
  void initState() {
    super.initState();
    usernameCtrl.addListener(updateTextValue);
    passwordCtrl.addListener(updateTextValue);
  }

  void updateTextValue() {
    setState(() {
      username = usernameCtrl.text;
      password = passwordCtrl.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(left: 32, right: 32, top: 200, bottom: 16),
              child: Column(
                  children: [
                    Text(
                      'Добро пожаловать!',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 64),
                    TextField(
                        controller: usernameCtrl,
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
                    SizedBox(height: 32),
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
                    SizedBox(height: 64),
                    TextButton(
                        onPressed: () async {
                          Future<User?> user = DbHandler.login(username, password, context);
                          User? userData = await user;

                          if (userData != null) {
                            Future<bool> result = Utils.saveUserInSP(username, password, userData.role_id!);
                            bool saved = await result;
                            if (saved) {
                              if (userData.role_id == 1) {
                                print("Role -> CUSTOMER");
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
                              }
                              else if (userData.role_id == 2) {
                                print("Role -> ADMIN");
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPage()));
                              }
                              else if (userData.role_id == 3) {
                                print("Role -> DELIVERYMAN");
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeliveryManPage()));
                              }
                            }
                          }
                        },
                        child: Text(
                          'Войти',
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
                          Navigator.pushNamed(context, "/register");
                        },
                        child: Text(
                          'Новый аккаунт',
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
        )
    );
  }
}