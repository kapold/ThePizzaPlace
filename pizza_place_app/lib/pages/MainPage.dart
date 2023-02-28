import 'package:flutter/material.dart';
import 'package:pizza_place_app/classes/AppColor.dart';
import 'package:pizza_place_app/pages/CartPage.dart';
import 'package:pizza_place_app/pages/ContactsPage.dart';
import 'package:pizza_place_app/pages/MenuPage.dart';
import 'package:pizza_place_app/pages/ProfilePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentChildIndex = 0;
  final List<Widget> _children = [
    MenuPage(),
    ProfilePage(),
    ContactsPage(),
    CartPage()
  ];

  void onBnbTapped(int index) {
    setState(() {
      _currentChildIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentChildIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: AppColor.pumpkin,
        unselectedItemColor: Colors.white,
        onTap: onBnbTapped,
        currentIndex: _currentChildIndex,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/pizzaBarIcon.png')),
            label: 'Меню'
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/profileBarIcon.png')),
              label: 'Профиль'
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/contactsBarIcon.png')),
              label: 'Контакты'
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icons/cartBarIcon.png')),
              label: 'Корзина'
          )
        ]
      ),
    );
  }
}