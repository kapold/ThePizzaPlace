import 'package:flutter/material.dart';
import 'package:pizza_place_app/pages/OrdersPage.dart';
import 'package:pizza_place_app/utils/AppColor.dart';
import 'package:pizza_place_app/pages/CartPage.dart';
import 'package:pizza_place_app/pages/MenuPage.dart';
import 'package:pizza_place_app/pages/ProfilePage.dart';
import 'package:pizza_place_app/utils/DbHandler.dart';
import 'package:pizza_place_app/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    OrdersPage(),
    CartPage()
  ];

  void onBnbTapped(int index) {
    setState(() {
      _currentChildIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? usernameSP = prefs.getString('username');
    String? passwordSP = prefs.getString('password');
    Utils.currentUser = await DbHandler.login(usernameSP!, passwordSP!, context);
    print(Utils.currentUser);
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
              icon: ImageIcon(AssetImage('assets/icons/orders.png')),
              label: 'Заказы'
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