import 'package:pizza_place_app/models/PizzaDetails.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/CartItem.dart';
import '../models/Order.dart';
import '../models/OrderItem.dart';
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

        db.execute('''
          CREATE TABLE Orders (
            id INTEGER PRIMARY KEY,
            user_id INTEGER NOT NULL,
            delivery_id INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            status TEXT NOT NULL
          );
        '''
        );
        print("< Table 'Orders' created >");

        db.execute('''
          CREATE TABLE OrderItems (
            id INTEGER PRIMARY KEY,
            order_id INTEGER NOT NULL,
            product_id INTEGER NOT NULL,
            pizza_details_id INTEGER NOT NULL,
            quantity INTEGER NOT NULL
          );
        '''
        );
        print("< Table 'OrderItems' created >");
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

  Future<void> clearHistory() async {
    final db = await database;
    db.delete('Orders');
    db.delete('OrderItems');
  }

  Future<List<Order>> getOrders(int? user_id) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> results = await db.rawQuery('''
        SELECT * FROM Orders WHERE user_id = ${user_id}
      ''');
      final List<Order> orders = [];
      for (final row in results) {
        final order = Order(
          id: row['id'],
          user_id: row['user_id'],
          delivery_id: row['delivery_id'],
          created_at: row['created_at'],
          status: row['status']
        );
        orders.add(order);
      }
      return orders;
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  Future<List<OrderItem>> getOrderItems() async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> results = await db.rawQuery('''
        SELECT * FROM OrderItems
      ''');
      final List<OrderItem> orderItems = [];
      for (final row in results) {
        final orderItem = OrderItem(
            id: row['id'],
            order_id: row['order_id'],
            product_id: row['product_id'],
            pizza_details_id: row['pizza_details_id'],
            quantity: row['quantity']
        );
        orderItems.add(orderItem);
      }
      return orderItems;
    } catch (e) {
      print('Error getting order items: $e');
      return [];
    }
  }

  Future<void> addOrder(Order order) async {
    final db = await database;
    try {
      await db.rawInsert(
          'INSERT INTO Orders(id, user_id, delivery_id, created_at, status) '
              'VALUES(?, ?, ?, ?, ?)',
          [order.id, order.user_id, order.delivery_id, order.created_at, order.status]);
    }
    catch (e) {
      print('Error inserting order: $e');
    }
  }

  Future<void> addOrderItem(OrderItem item) async {
    final db = await database;
    try {
      await db.rawInsert(
          'INSERT INTO OrderItems(id, order_id, product_id, pizza_details_id, quantity) '
              'VALUES(?, ?, ?, ?, ?)',
          [item.id, item.order_id, item.product_id, item.pizza_details_id, item.quantity]);
    }
    catch (e) {
      print('Error inserting order item: $e');
    }
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