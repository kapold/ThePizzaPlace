import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/AppColor.dart';
import 'package:pizza_place_app/utils/DbHandler.dart';

import '../models/Order.dart';
import '../utils/Utils.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> orders = [];
  bool areThereOrders = false;

  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  void _getOrders() async {
    orders = await DbHandler.getUserOrders(Utils.currentUser?.id, "in progress", context);
    if (orders.isNotEmpty) {
      print("Orders count: ${orders.length}");
      for(Order order in orders)
        order.items = await DbHandler.getOrderItems(order.id, context);
      areThereOrders = true;
    }
    Utils.showListInfo(orders);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: areThereOrders ?
        Center(
          child: Text(
            "Заказов нет. \nЖдем с нетерпением :)",
            style: TextStyle(fontSize: 20, color: AppColor.pumpkin, fontStyle: FontStyle.italic)
          )
        ) :
        Center(
          child: CircularProgressIndicator(color: AppColor.pumpkin)
        )
    );
  }
}