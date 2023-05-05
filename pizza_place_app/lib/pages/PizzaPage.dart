import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_place_app/models/CartItem.dart';
import 'package:pizza_place_app/utils/AppColor.dart';
import 'package:pizza_place_app/utils/CustomSearchDelegate.dart';
import 'package:pizza_place_app/utils/SQLiteHandler.dart';

import '../models/Pizza.dart';
import '../utils/DbHandler.dart';
import '../utils/Utils.dart';
import '../widgets/ListViewMenu.dart';

class PizzaPage extends StatefulWidget {
  const PizzaPage({Key? key}) : super(key: key);

  @override
  State<PizzaPage> createState() => _PizzaPageState();
}

class _PizzaPageState extends State<PizzaPage> {
  int _selectedSizeSegmentIndex = 0, _selectedDoughSegmentIndex = 0,
      _selectedCheeseSegmentIndex = 0;
  double _additionalSizePrice = 0, _additionalCheesePrice = 0;
  String _selectedSize = "25 см", _selectedDough = "Тонкое", _selectedCheese = "Без сыра";
  final Map<int, Widget> _sizeChildren = {
    0: Container(
      padding: EdgeInsets.fromLTRB(40,12,40,12),
      child: Text('25 см'),
    ),
    1: Container(
      padding: EdgeInsets.fromLTRB(40,12,40,12),
      child: Text('30 см'),
    ),
    2: Container(
      padding: EdgeInsets.fromLTRB(40,12,40,12),
      child: Text('35 см'),
    )
  };
  final Map<int, Widget> _doughChildren = {
    0: Container(
      padding: EdgeInsets.fromLTRB(40,12,40,12),
      child: Text('Тонкое'),
    ),
    1: Container(
      padding: EdgeInsets.fromLTRB(40,12,40,12),
      child: Text('Традиционное'),
    )
  };
  final Map<int, Widget> _cheeseChildren = {
    0: Container(
      padding: EdgeInsets.fromLTRB(40,12,40,12),
      child: Text('Без сыра'),
    ),
    1: Container(
      padding: EdgeInsets.fromLTRB(40,12,40,12),
      child: Text('С сыром'),
    )
  };

  @override
  Widget build(BuildContext context) {
    final Pizza currentPizza =
        ModalRoute.of(context)!.settings.arguments as Pizza;

    return Scaffold(
      appBar: AppBar(title: Text('${currentPizza.name}')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child:  Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/icons/burger_pi.png'),
            ),
            padding: EdgeInsets.only(right: 100, left: 100)
          ),
          Expanded(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${currentPizza.name}',
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              '${currentPizza.description}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Размер пиццы',
                              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 400,
                              child: CupertinoSegmentedControl(
                                selectedColor: AppColor.pumpkin,
                                borderColor: AppColor.pumpkin,
                                children: _sizeChildren,
                                groupValue: _selectedSizeSegmentIndex,
                                onValueChanged: (value) {
                                  setState(() {
                                    _selectedSizeSegmentIndex = value;
                                    if(_selectedSizeSegmentIndex == 0) {
                                      _selectedSize = "25 см";
                                      _additionalSizePrice = 0;
                                    }
                                    else if(_selectedSizeSegmentIndex == 1) {
                                      _selectedSize = "30 см";
                                      _additionalSizePrice = 8;
                                    }
                                    else if(_selectedSizeSegmentIndex == 2) {
                                      _selectedSize = "35 см";
                                      _additionalSizePrice = 12;
                                    }
                                  });
                                },
                              )
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Тесто',
                              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 400,
                              child: CupertinoSegmentedControl(
                                selectedColor: AppColor.pumpkin,
                                borderColor: AppColor.pumpkin,
                                children: _doughChildren,
                                groupValue: _selectedDoughSegmentIndex,
                                onValueChanged: (value) {
                                  setState(() {
                                    _selectedDoughSegmentIndex = value;
                                    if(_selectedDoughSegmentIndex == 0)
                                      _selectedDough = "Тонкое";
                                    else if(_selectedDoughSegmentIndex == 1)
                                      _selectedDough = "Традиционное";
                                  });
                                },
                              )
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Сырные бортики',
                              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 400,
                              child: CupertinoSegmentedControl(
                                selectedColor: AppColor.pumpkin,
                                borderColor: AppColor.pumpkin,
                                children: _cheeseChildren,
                                groupValue: _selectedCheeseSegmentIndex,
                                onValueChanged: (value) {
                                  setState(() {
                                    _selectedCheeseSegmentIndex = value;
                                    if(_selectedCheeseSegmentIndex == 0) {
                                      _selectedCheese = "Без сыра";
                                      _additionalCheesePrice = 0;
                                    }
                                    else if(_selectedCheeseSegmentIndex == 1) {
                                      _selectedCheese = "С сыром";
                                      _additionalCheesePrice = 5;
                                    }
                                  });
                                },
                              )
                            )
                          ],
                        ),
                      ),
                    ]
                )
            )
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: TextButton(
                onPressed: () async {
                  CartItem cartItem = CartItem(
                    pizza_id: currentPizza.id,
                    quantity: 1,
                    name: currentPizza.name,
                    size: _selectedSize,
                    dough: _selectedDough,
                    cheese: _selectedCheese,
                    price: currentPizza.price,
                    image: currentPizza.image
                  );
                  await SQLiteHandler().addPizza(cartItem);
                  Utils.showAlertDialog(context, "Товар добавлен в корзину!");
                },
                child: Text(
                  'Добавить в корзину за ${(currentPizza.price! + _additionalSizePrice + _additionalCheesePrice).toStringAsFixed(2)}',
                  style: TextStyle(
                      color: AppColor.pumpkin,
                      fontSize: 18
                  ),
                ),
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: AppColor.pumpkin)
                    ),
                    padding: EdgeInsets.only(top: 20, bottom: 20)
                )
            )
          )
        ],
      ),
    );
  }
}
