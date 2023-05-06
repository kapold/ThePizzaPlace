import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/AppColor.dart';

import '../models/Pizza.dart';
import '../pages/PizzaPage.dart';
import '../utils/DbHandler.dart';
import '../utils/Utils.dart';

class DismissibleListView extends StatefulWidget {
  @override
  _DismissibleListViewState createState() => _DismissibleListViewState();
}

class _DismissibleListViewState extends State<DismissibleListView> {
  List<Pizza> pizzas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPizzas();
  }

  Future<void> _fetchPizzas() async {
    try {
      pizzas = await DbHandler.fetchPizzas();
      Utils.pizzas = pizzas;
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget createPizzaContainer(Pizza pizza) {
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
      child: Row(
        children: [
          SizedBox(width: 16),
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/icons/burger_pi.png'),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pizza.name}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${pizza.description}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: AppColor.pumpkin,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(
                      '${pizza.price} BYN',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                )
              ],
            ),
          ),
          SizedBox(width: 16)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
        itemCount: pizzas.length,
        itemBuilder: (BuildContext context, int index) {
          final pizza = pizzas[index];
          return Dismissible(
            key: Key(pizza.name.toString()),
            onDismissed: (direction) async {
              await DbHandler.deletePizza(pizza.id!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Пицца `${pizza.name.toString()}` удалена'),
                ),
              );
            },
            background: Container(
              color: AppColor.pumpkin,
              child: Icon(Icons.delete),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 16.0),
            ),
            child: createPizzaContainer(pizza)
          );
        }
    );
  }
}