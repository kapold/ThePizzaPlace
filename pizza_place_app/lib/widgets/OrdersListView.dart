import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/AppColor.dart';

import '../models/Order.dart';
import '../models/OrderItem.dart';
import '../utils/DbHandler.dart';
import '../utils/Utils.dart';

class OrdersListView extends StatefulWidget {
  @override
  _OrdersListViewState createState() => _OrdersListViewState();
}

class _OrdersListViewState extends State<OrdersListView> {
  List<Order> orders = [];
  bool areThereOrders = false;

  @override
  void initState() {
    super.initState();
    _fetchPizzas();
    _getOrders();
  }

  Future<void> _fetchPizzas() async {
    try {
      Utils.pizzas = await DbHandler.fetchPizzas();
    } catch (e) {
      print(e);
    }
  }

  void _getOrders() async {
    orders = await DbHandler.getOrders("in progress", context);
    if (orders.isNotEmpty) {
      for(Order order in orders)
        order.items = await DbHandler.getOrderItems(order.id, context);
      areThereOrders = true;
    }
    setState(() {});
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
    return orders.isNotEmpty
        ? Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                final order = orders[index];
                return Dismissible(
                    key: Key(order.id.toString()),
                    onDismissed: (direction) async {
                      await DbHandler.updateOrderStatus(order.id!, "done");
                      orders.remove(order);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Заказ №`${order.id.toString()}` доставлен'),
                        ),
                      );
                    },
                    background: Container(
                      color: AppColor.pumpkin,
                      child: Icon(Icons.done_all, size: 40),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 32.0),
                    ),
                    child: createOrderContainer(order)
                );
              },
            ),
          ),
        ])
        : Center(
          child: Text(
          "Заказов нет",
          style: TextStyle(fontSize: 20, color: AppColor.pumpkin, fontStyle: FontStyle.italic),
        )
    );
  }
}