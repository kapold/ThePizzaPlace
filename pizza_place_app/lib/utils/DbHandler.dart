import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_place_app/models/Address.dart';
import 'package:pizza_place_app/models/PizzaDetails.dart';
import 'package:pizza_place_app/utils/Utils.dart';
import '../models/Order.dart';
import '../models/OrderItem.dart';
import '../models/Pizza.dart';
import '../models/User.dart';

class DbHandler {
  static String baseUri = "http://10.0.2.2:3000";

  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUri + '/users'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonResponse);
      List<User> users = data.map((json) => User.fromJson(json)).toList();
      return users;
    } else {
      throw Exception('Failed to load customers');
    }
  }

  static Future<List<Pizza>> fetchPizzas() async {
    final response = await http.get(Uri.parse(baseUri + '/pizzas'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonResponse);
      List<Pizza> pizzas = data.map((json) => Pizza.fromJson(json)).toList();
      return pizzas;
    } else {
      throw Exception('Failed to load pizzas');
    }
  }

  static Future<bool> addUser(User user, BuildContext context) async {
    final url = Uri.parse(baseUri + '/users');
    final headers = { 'Content-Type': 'application/json' };
    final body = json.encode({
      'username': user.username,
      'password': user.password,
      'phone_number': user.phone_number,
      'birthday': user.birthday
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode != 201) {
      if (response.statusCode == 500) {
        Utils.showAlertDialog(context, "Такое имя уже занято, выберите другое.");
        return false;
      }
    }
    return true;
  }

  static Future<int> addOrder(int user_id, int delivery_id, String status, BuildContext context) async {
    final url = Uri.parse(baseUri + '/orders');
    final headers = { 'Content-Type': 'application/json' };
    final body = json.encode({
      'user_id': user_id,
      'delivery_id': delivery_id,
      'status': status
    });

    final response = await http.post(url, headers: headers, body: body);
    print("Body: ${response.body}");
    List<dynamic> parsedJson = jsonDecode(response.body);
    int createOrder = parsedJson[0]["create_order"];
    return createOrder;
  }

  static Future<void> addOrderDetails(int order_id, int pizza_details_id, int quantity, int product_id, BuildContext context) async {
    final url = Uri.parse(baseUri + '/order_details');
    final headers = { 'Content-Type': 'application/json' };
    final body = json.encode({
      'order_id': order_id,
      'pizza_details_id': pizza_details_id,
      'quantity': quantity,
      'product_id': product_id
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
    }
    catch (e) {
      print(e);
    }
  }

  static Future<User?> login(String username, String password, BuildContext context) async {
    final url = Uri.parse(baseUri + '/login');
    final headers = { 'Content-Type': 'application/json' };
    final body = json.encode({
      'username': username,
      'password': password,
    });

    try {
      print("Name: ${username}, Password: ${password}");
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return User.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (e) {
      Utils.showAlertDialog(context, "Неверный логин или пароль");
      return null;
    }
  }

  static Future<User?> getUserByName(String username, BuildContext context) async {
    final url = Uri.parse(baseUri + '/get_user_by_username');
    final headers = { 'Content-Type': 'application/json' };
    final body = json.encode({
      'username': username
    });

    try {
      print("Name: ${username}");
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return User.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (e) {
      Utils.showAlertDialog(context, "Неверный логин");
      return null;
    }
  }

  static Future<bool> updateUser(User user, BuildContext context) async {
    final url = Uri.parse(baseUri + '/users');
    final headers = { 'Content-Type': 'application/json' };
    final body = json.encode({
      'id': user.id,
      'username': user.username,
      'phone_number': user.phone_number,
      'birthday': user.birthday
    });

    final response = await http.put(url, headers: headers, body: body);
    if (response.statusCode != 201) {
      if (response.statusCode == 500) {
        Utils.showAlertDialog(context, "Проверьте правильность данных");
        return false;
      }
    }
    return true;
  }

  static Future<List<Address>> getUserAddresses(int? user_id, BuildContext context) async {
    final response = await http.get(Uri.parse(baseUri + '/addresses/$user_id'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonResponse);
      List<Address> addresses = data.map((json) => Address.fromJson(json)).toList();
      return addresses;
    } else {
      return [];
    }
  }

  static Future<List<Order>> getUserOrders(int? user_id, String status, BuildContext context) async {
    final url = Uri.parse(baseUri + '/orders?user_id=$user_id&status=$status');
    final headers = { 'Content-Type': 'application/json' };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonResponse);
        List<Order> orders = data.map((json) => Order.fromJson(json)).toList();
        return orders;
      } else {
        return [];
      }
    } catch (e) {
      Utils.showAlertDialog(context, "Список заказов пуст");
      return [];
    }
  }

  static Future<List<OrderItem>> getOrderItems(int? order_id, BuildContext context) async {
    final url = Uri.parse(baseUri + '/order_details?order_id=$order_id');
    final headers = { 'Content-Type': 'application/json' };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonResponse);
        List<OrderItem> orderItems = data.map((json) => OrderItem.fromJson(json)).toList();
        return orderItems;
      } else {
        return [];
      }
    } catch (e) {
      Utils.showAlertDialog(context, "Ошибка получения информации о заказе");
      return [];
    }
  }

  static Future<bool> addAddress(Address address, BuildContext context) async {
    final url = Uri.parse(baseUri + '/addresses');
    final headers = { 'Content-Type': 'application/json' };
    final body = json.encode({
      'user_id': address.user_id,
      'address': address.address,
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode != 201) {
      if (response.statusCode == 500) {
        Utils.showAlertDialog(context, "Такой адрес уже есть");
        return false;
      }
    }
    return true;
  }

  static Future<void> deleteUserAddress(int addressID) async {
    var url = Uri.parse(baseUri + '/addresses/${addressID.toString()}');

    var response = await http.delete(url);
    if (response.statusCode != 200 && response.statusCode != 201)
      throw Exception('Failed to delete Address');
  }

  static Future<List<PizzaDetails>> getPizzaDetails() async {
    final response = await http.get(Uri.parse(baseUri + '/pizza_details'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonResponse);
      List<PizzaDetails> details = data.map((json) => PizzaDetails.fromJson(json)).toList();
      return details;
    } else {
      return [];
    }
  }

  // static Future<List<Order>> getUserOrders(int user_id) async {
  //   final response = await http.get(Uri.parse(baseUri + '/user_orders'));
  //
  //
  // }
}