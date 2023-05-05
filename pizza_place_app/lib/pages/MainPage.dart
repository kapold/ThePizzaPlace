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
    String? usernameSP = await prefs.getString('username');
    String? passwordSP = await prefs.getString('password');
    if (usernameSP != "" && passwordSP != "") {
      print("! Preferences loaded ! -> name: ${usernameSP}, password: ${passwordSP}");
      _loadUser(usernameSP!, passwordSP!);
    }
  }

  Future<void> _loadUser(String username, String password) async {
    print("! Try to get User !");
    Utils.currentUser = await DbHandler.login(username, password, context);
    print(Utils.currentUser);
    if (Utils.currentUser != null) {
      print("! User logged !");
      Utils.userAddresses = await DbHandler.getUserAddresses(Utils.currentUser?.id, context);
      print("Количество адресов пользователя: ${Utils.userAddresses.length}");
    } else {
      Utils.userAddresses = [];
    }
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