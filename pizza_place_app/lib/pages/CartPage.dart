import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pizza_place_app/utils/SQLiteHandler.dart';

import '../models/Address.dart';
import '../models/CartItem.dart';
import '../utils/AppColor.dart';
import '../utils/Utils.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cart = [];
  bool isLoading = true;
  double _totalPrice = 0;
  late String _selectedItem;
  // TODO: create Cart

  @override
  void initState() {
    super.initState();
    _showCart();
  }

  Future<void> _showCart() async {
    double p = 0;
    try {
      cart = await SQLiteHandler().getPizzasInCart();
      p = _getTotalPrice();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
        _totalPrice = p;
      });
    }
  }

  double _getTotalPrice() {
    double addPriceForSize = 0, addPriceForCheese = 0, totalPrice = 0;
    for(CartItem item in cart) {
      if (item.cheese == "С сыром")
        addPriceForCheese = 5;

      if (item.size == "30 см")
        addPriceForSize = 8;
      else if (item.size == "35 см")
        addPriceForSize = 12;

      String totalPriceForItem = ((item.price! + addPriceForCheese + addPriceForSize) * item.quantity!).toStringAsFixed(2);
      totalPrice += double.parse(totalPriceForItem);
    }
    return totalPrice;
  }

  Widget createCartItem(CartItem item) {
    double addPriceForSize = 0, addPriceForCheese = 0;
    if (item.cheese == "С сыром")
      addPriceForCheese = 5;

    if (item.size == "30 см")
      addPriceForSize = 8;
    else if (item.size == "35 см")
      addPriceForSize = 12;

    String totalPriceForItem = ((item.price! + addPriceForCheese + addPriceForSize) * item.quantity!).toStringAsFixed(2);

    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppColor.pumpkin,
          width: 1
        )
      ),
      child: Column(
        children: [
          Row(
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
                          '${item.name}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                            '${item.dough.toString()}, ${item.cheese.toString()}, ${item.size.toString()}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            )
                        ),
                      ]
                  )
              ),
            ],
          ),
          Divider(color: AppColor.pumpkin),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${totalPriceForItem} BYN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.pumpkin
                    )
                  ),
                  Container(
                    height: 40,
                    width: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor.pumpkin,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (item.quantity == 1)
                              return;
                            SQLiteHandler().decrementQuantity(item.pizza_id!);
                            setState(() {
                              item.quantity = item.quantity! - 1;
                              _totalPrice = _getTotalPrice();
                            });
                          },
                          icon: Icon(Icons.remove,  color: AppColor.pumpkin)
                        ),
                        Text(
                          item.quantity.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        IconButton(
                          onPressed: () {
                            if (item.quantity == 10)
                              return;
                            SQLiteHandler().incrementQuantity(item.pizza_id!);
                            setState(() {
                              item.quantity = item.quantity! + 1;
                              _totalPrice = _getTotalPrice();
                            });
                          },
                          icon: Icon(Icons.add, color: AppColor.pumpkin)
                        ),
                      ],
                    ),
                  )
                ]
              )
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: isLoading ?
          Image.asset('assets/icons/emptyCart.png') :
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemExtent: 234,
                    itemBuilder: (BuildContext context, int index) {
                      CartItem item = cart[index];
                      return createCartItem(item);
                    }
                  )
                ),
                Divider(),
                DropdownButton<String>(
                  value: _selectedItem,
                  items: Utils.userAddresses.map((Address item) {
                    return DropdownMenuItem<String>(
                      value: item.toString(),
                      child: Text(item.toString()),
                    );
                  }).toList(),
                  onChanged: (String? selectedItem) {
                    setState(() {
                      _selectedItem = selectedItem!;
                    });
                  },
                ),
                SizedBox(height: 6),
                TextButton(
                    onPressed: () {

                    },
                    child: Text(
                      'Оформить заказ за ${_totalPrice.toStringAsFixed(2)} BYN',
                      style: TextStyle(
                          color: AppColor.pumpkin,
                          fontSize: 18
                      ),
                    ),
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(color: AppColor.pumpkin)
                        ),
                        padding: EdgeInsets.only(top: 14, bottom: 14, right: 60, left: 60)
                    )
                ),
                SizedBox(height: 10)
              ]
            )
          )
      ),
    );
  }
}