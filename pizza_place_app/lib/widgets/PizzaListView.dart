import 'package:flutter/material.dart';

import '../models/Pizza.dart';
import '../pages/PizzaPage.dart';
import '../utils/AppColor.dart';

class PizzaListView extends StatefulWidget {
  final List<Pizza> pizzas;

  const PizzaListView({Key? key, required this.pizzas}) : super(key: key);

  @override
  _PizzaListViewState createState() => _PizzaListViewState();
}

class _PizzaListViewState extends State<PizzaListView> {
  late List<Pizza> pizzas;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    pizzas = widget.pizzas;
  }

  Widget createPizzaContainer(Pizza pizza) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      margin: const EdgeInsets.all(16),
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
          const SizedBox(width: 16),
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pizza.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${pizza.description}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: AppColor.pumpkin,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '${pizza.price} BYN',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 16)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: pizzas.length,
        itemBuilder: (BuildContext context, int index) {
          final pizza = pizzas[index];
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PizzaPage(),
                        settings: RouteSettings(arguments: pizza)));
              },
              child: createPizzaContainer(pizza));
        });
  }
}