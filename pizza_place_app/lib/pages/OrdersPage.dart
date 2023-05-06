import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/AppColor.dart';
import 'package:pizza_place_app/utils/DbHandler.dart';

import '../models/Order.dart';
import '../models/OrderItem.dart';
import '../models/Pizza.dart';
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
    setState(() {});
    //Utils.showListInfo(orders);
  }

  Widget createOrderContainer(Order order) {
    String orderInfo = "";
    for(OrderItem item in order.items!) {
      String? pizzaName = Utils.pizzas.where((pizza) => pizza.id == item.product_id).first.name;
      orderInfo += "${pizzaName} (x${item.quantity})\n";
    }

    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: AppColor.pumpkin,
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Заказ №${order.id}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                child: Text(
                    orderInfo,
                    style: TextStyle(fontSize: 18)
                )
              )
            ]
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: orders.isNotEmpty
      ? Column(
        children: [
          Text(
            "В процессе",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColor.pumpkin)
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                return createOrderContainer(orders[index]);
              },
            ),
          ),
        ]
      )
      : Center(
        child: Text(
          "Заказов нет. \nЖдем с нетерпением :)",
          style: TextStyle(fontSize: 20, color: AppColor.pumpkin, fontStyle: FontStyle.italic),
        ),
      )
    );
  }
}