import 'package:pizza_place_app/models/PizzaDetails.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/CartItem.dart';
import '../models/Pizza.dart';

class SQLiteHandler {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null)
      return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'pizzaria.db');
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Pizzas(
              id INTEGER PRIMARY KEY, 
              name TEXT, 
              size TEXT, 
              dough TEXT, 
              cheese TEXT, 
              price REAL, 
              image TEXT
          );
          '''
        );
        print("< Table 'Pizzas' created >");

        db.execute('''
          CREATE TABLE Cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            quantity INTEGER NOT NULL DEFAULT 1,
            pizza_id INTEGER NOT NULL,
            FOREIGN KEY (pizza_id) REFERENCES Pizzas(id)
          );
        '''
        );
        print("< Table 'Cart' created >");
      },
    );
    _database = database;
    return database;
  }

  Future<void> clearPizzas() async {
    final db = await database;
    await db.delete('Cart');
    await db.delete('Pizzas');
  }

  Future<void> addPizza(CartItem item) async {
    final db = await database;
    try {
      await db.rawInsert(
          'INSERT INTO Pizzas(id, name, size, dough, cheese, price, image) '
              'VALUES(?, ?, ?, ?, ?, ?, ?)',
          [item.pizza_id, item.name, item.size, item.dough, item.cheese, item.price, item.image]);
      await db.rawInsert(
          'INSERT INTO Cart(quantity, pizza_id) '
              'VALUES(?, ?)',
          [1, item.pizza_id]);
    }
    catch (e) {
      print('Error inserting pizza and cart: $e');
    }
  }

  Future<List<CartItem>> getPizzasInCart() async {
    try {
      final Database db = await database;

      final List<Map<String, dynamic>> results = await db.rawQuery('''
        SELECT Cart.id, Cart.pizza_id, Pizzas.name, Pizzas.size, Pizzas.dough, Pizzas.cheese,
             Pizzas.price, Pizzas.image, Cart.quantity
        FROM Pizzas
        JOIN Cart ON Pizzas.id = Cart.pizza_id
      ''');

      final List<CartItem> cartItems = [];

      for (final row in results) {
        final cartItem = CartItem(
          id: row['id'],
          pizza_id: row['pizza_id'],
          quantity: row['quantity'],
          name: row['name'],
          size: row['size'],
          dough: row['dough'],
          cheese: row['cheese'],
          price: row['price'],
          image: row['image'],
        );
        cartItems.add(cartItem);
      }

      return cartItems;
    } catch (e) {
      print('Error getting pizzas in cart: $e');
      return [];
    }
  }

  Future<void> incrementQuantity(int pizzaId) async {
    final Database db = await database;
    await db.rawUpdate('UPDATE Cart SET quantity = quantity + 1 WHERE pizza_id = ?', [pizzaId]);
  }

  Future<void> decrementQuantity(int pizzaId) async {
    final Database db = await database;
    // Получаем количество товаров в корзине для данного пиццы
    int? quantity = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT quantity FROM Cart WHERE pizza_id = ?',
      [pizzaId],
    ));

    if (quantity == 1) {
      // Если осталась 1 пицца в корзине, удаляем ее из таблицы Cart
      await db.delete('Cart', where: 'pizza_id = ?', whereArgs: [pizzaId]);
      await db.delete('Pizzas', where: 'id = ?', whereArgs: [pizzaId]);
    } else {
      // Иначе уменьшаем количество товаров в корзине на 1
      await db.update(
        'Cart',
        {'quantity': quantity! - 1},
        where: 'pizza_id = ?',
        whereArgs: [pizzaId],
      );
    }

    // Получаем количество товаров в корзине для данного пиццы после изменения
    quantity = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT quantity FROM Cart WHERE pizza_id = ?',
      [pizzaId],
    ));

    if (quantity == 0) {
      // Если количество товаров в корзине стало 0, удаляем запись из таблицы Pizzas
      await db.delete('Pizzas', where: 'id = ?', whereArgs: [pizzaId]);
    }
  }
}