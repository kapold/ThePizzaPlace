import 'package:pizza_place_app/models/PizzaDetails.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
          )
        '''
        );
        print("< Table 'Cart' created >");

        db.rawInsert('''
          INSERT INTO Pizzas (id, name, size, dough, cheese, price, image) 
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', [1, 'Margherita', '25 см', 'Толстое', 'Без сыра', 9.99, 'none']);
        print("< Inserted into Pizzas >");

        db.rawInsert('''
          INSERT INTO Cart (pizza_id, quantity) 
            VALUES (?, ?)
        ''', [1, 2]);
        print("< Inserted into Cart >");
      },
    );
    _database = database;
    return database;
  }

  Future<int> clearPizzas() async {
    final db = await database;
    return await db.delete('Pizzas');
  }

  Future<int> addPizza(Pizza pizza, PizzaDetails details) async {
    final db = await database;
    String sql = "";
    // String sql = '''
    //   INSERT INTO Pizzas(id, name, size, dough, cheese, price, quantity, image)
    //   VALUES(${pizza.id}, "${pizza.name}", "${size}", "${dough}", "${cheese}", ${totalPrice}, ${quantity}, "${pizza.image}")
    // ''';
    return await db.rawInsert(sql);
  }
}