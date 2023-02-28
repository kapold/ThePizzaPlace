import 'package:flutter/material.dart';
import 'package:pizza_place_app/pages/CartPage.dart';
import 'package:pizza_place_app/pages/ContactsPage.dart';
import 'package:pizza_place_app/pages/MenuPage.dart';
import 'package:pizza_place_app/pages/MainPage.dart';
import 'package:pizza_place_app/pages/ProfilePage.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/main',
    routes: {
      '/main': (context) => const MainPage(),
      '/menu': (context) => const MenuPage(),
      '/profile': (context) => const ProfilePage(),
      '/contacts': (context) => const ContactsPage(),
      '/cart': (context) => const CartPage()
    },
    theme: ThemeData(
      fontFamily: 'Ubuntu',
      useMaterial3: true
    ),
    debugShowCheckedModeBanner: false
));