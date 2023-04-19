import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/AppColor.dart';

import '../models/Pizza.dart';

class ListViewMenu extends StatelessWidget {
  final List<Pizza> pizzas = [
    Pizza(id: 1, name: 'Маргарита', description: 'Описаниеееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееееее',
        price: 20.99, image: 'none'),
    Pizza(id: 2, name: 'Цыпленок', description: 'Описание...', price: 21.99, image: 'none'),
    Pizza(id: 3, name: 'ПЕСТО', description: 'Описание...', price: 22.99, image: 'none')
  ];

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
            blurRadius: 10.0,
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
                Text(
                  '${pizza.price} ₽',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
    return ListView.builder(
      itemCount: pizzas.length,
        itemBuilder: (BuildContext context, int index) {
          final pizza = pizzas[index];
          return createPizzaContainer(pizza);
        }
    );
  }
}