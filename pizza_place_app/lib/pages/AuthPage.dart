import 'package:flutter/material.dart';

import '../utils/AppColor.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
                      onPressed: () {},
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
    );
  }
}