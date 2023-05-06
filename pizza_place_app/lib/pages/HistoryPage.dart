import 'package:flutter/material.dart';

import '../models/Order.dart';
import '../models/OrderItem.dart';
import '../utils/AppColor.dart';
import '../utils/DbHandler.dart';
import '../utils/Utils.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Order> orders = [];
  bool areThereOrders = false;

  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  void _getOrders() async {
    orders = await DbHandler.getUserOrders(Utils.currentUser?.id, "done", context);
    if (orders.isNotEmpty) {
      for(Order order in orders)
        order.items = await DbHandler.getOrderItems(order.id, context);
      areThereOrders = true;
    }
    setState(() {});
  }

  Widget createHistoryContainer(Order order) {
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
                  'Заказ №${order.id} (от ${order.created_at?.substring(0, 10)})',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('История заказов'),
      ),
      body: orders.isNotEmpty
          ? Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  return createHistoryContainer(orders[index]);
                },
              ),
            )
          ]
        ) : Center(
        child: Padding(
          padding: EdgeInsets.only(right: 64, left: 64, bottom: 120),
          child: Text(
            "Сделайте пару заказов, чтобы появилась история",
            style: TextStyle(fontSize: 20, color: AppColor.pumpkin, fontStyle: FontStyle.italic),
          )
        )
      )
    );
  }
}