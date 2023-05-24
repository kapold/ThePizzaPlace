import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_place_app/utils/AppColor.dart';
import 'package:pizza_place_app/utils/CustomSearchDelegate.dart';
import 'package:pizza_place_app/utils/SQLiteHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Order.dart';
import '../models/OrderItem.dart';
import '../utils/DbHandler.dart';
import '../utils/Utils.dart';
import '../widgets/ListViewMenu.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late String _timeString;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
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
    Utils.currentUser = await DbHandler.login(username, password, context);
    print(Utils.currentUser);
    if (Utils.currentUser != null) {
      print("! User logged !");
      Utils.userAddresses = await DbHandler.getUserAddresses(Utils.currentUser?.id, context);
      print("Количество адресов пользователя: ${Utils.userAddresses.length}");
      if (!kIsWeb)
        _createLocalDB();
    } else {
      Utils.userAddresses = [];
    }
  }

  void _createLocalDB() async {
    Future<bool> result = _initLocalDB();
    if (await result) {
      _tryToGetOrdersHistory();
    }
  }

  Future<bool> _initLocalDB() async {
    SQLiteHandler sqLiteHandler = SQLiteHandler();
    await sqLiteHandler.initializeDatabase();
    return true;
  }

  Future<void> _tryToGetOrdersHistory() async {
    try {
      Utils.history = await DbHandler.getUserOrders(Utils.currentUser!.id, "done", context);
      Utils.historyItems = await DbHandler.getAllOrderItems(context);

      if (Utils.history.isNotEmpty) {
        print("! Заказы получены из внешней БД, сохраняю локально !");
        print("<-------------------- Синхронизация(начало) -------------------->");

        try {
          SQLiteHandler().clearHistory();
          print("Очистка истории - успешно");

          print("Orders count -> ${Utils.history.length}");
          print("Items count -> ${Utils.historyItems.length}");

          _fillDbWithOrders();
          _fillDbWithOrderItems();

          print("<-------------------- Синхронизация(конец) -------------------->");
        }
        catch (e) {
          print("Что-то пошло не так с сохранением локально: ${e}");
        }
      }
    }
    catch (e) {
      print("Ошибка получения истории заказов с сервера");
    }
  }

  void _fillDbWithOrders() {
    for(Order order in Utils.history)
      SQLiteHandler().addOrder(order);
    print("Сохранение 'Orders' локально - успешно");
  }

  void _fillDbWithOrderItems() {
    for(OrderItem item in Utils.historyItems)
      SQLiteHandler().addOrderItem(item);
    print("Сохранение 'OrderItems' локально - успешно");
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }

  void _getCurrentTime() {
    if (mounted) {
      setState(() {
        _timeString = _formatDateTime(DateTime.now());
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: Row(
                    children: [
                      Text(
                        _timeString,
                        style: TextStyle(color: Colors.black),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Image.asset("assets/icons/clock.png", width: 16, height: 16)
                    ],
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.pumpkin,
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 16)),
                IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: CustomSearchDelegate()
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
                Padding(padding: EdgeInsets.only(left: 16))
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Container(
              padding: EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                  'Выгодно и вкусно',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
              )
          ),
          Padding(padding: EdgeInsets.all(10)),
          Expanded(
              child: ListViewMenu()
          )
        ],
      )
    );
  }
}