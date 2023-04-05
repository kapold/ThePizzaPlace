import 'package:flutter/material.dart';
import 'package:pizza_place_app/pages/AuthPage.dart';
import 'package:pizza_place_app/pages/CartPage.dart';
import 'package:pizza_place_app/pages/MenuPage.dart';
import 'package:pizza_place_app/pages/MainPage.dart';
import 'package:pizza_place_app/pages/OrdersPage.dart';
import 'package:pizza_place_app/pages/ProfilePage.dart';
import 'package:pizza_place_app/pages/AboutAppPage.dart';
import 'package:pizza_place_app/pages/RegisterPage.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/auth',
    routes: {
      '/register': (context) => const RegisterPage(),
      '/auth': (context) => const AuthPage(),
      '/main': (context) => const MainPage(),
      '/menu': (context) => const MenuPage(),
      '/profile': (context) => const ProfilePage(),
      '/orders': (context) => const OrdersPage(),
      '/cart': (context) => const CartPage(),
      '/aboutApp': (context) => const AboutAppPage()
    },
    theme: ThemeData(
      fontFamily: 'Ubuntu',
      useMaterial3: true
    ),
    debugShowCheckedModeBanner: false
));