import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/AppColor.dart';
import 'package:pizza_place_app/utils/DbHandler.dart';
import 'package:pizza_place_app/widgets/PizzaListView.dart';

import '../models/Pizza.dart';
import '../pages/PizzaPage.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<Pizza> searchTerms = [];

  Future<void> fetchData() async {
    searchTerms = await DbHandler.fetchPizzas();
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

  // First overwrite to clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // Second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // Third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<Pizza> matchQuery = [];
    for (var pizza in searchTerms) {
      if (pizza.name!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(pizza);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return PizzaListView(pizzas: matchQuery);;
      },
    );
  }

  // Last overwrite to show the querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        List<Pizza> matchQuery = [];
        for (var pizza in searchTerms) {
          if (pizza.name!.toLowerCase().contains(query.toLowerCase())) {
            matchQuery.add(pizza);
          }
        }

        return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (BuildContext context, int index) {
              final pizza = matchQuery[index];
              return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PizzaPage(),
                            settings: RouteSettings(arguments: pizza)
                        ));
                  },
                  child: createPizzaContainer(pizza)
              );
        });
      },
    );
  }
}