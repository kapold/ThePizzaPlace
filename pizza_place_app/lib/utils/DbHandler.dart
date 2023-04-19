import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_place_app/utils/Utils.dart';
import '../models/User.dart';

class DbHandler {
  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('http://localhost:3000/users'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonResponse);
      List<User> users = data.map((json) => User.fromJson(json)).toList();
      return users;
    } else {
      throw Exception('Failed to load customers');
    }
  }

  static Future<bool> addUser(User user, BuildContext context) async {
    final url = Uri.parse('http://localhost:3000/users');
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

  static Future<User?> login(String username, String password, BuildContext context) async {
    final url = Uri.parse('http://localhost:3000/login');
    final headers = { 'Content-Type': 'application/json' };
    final body = json.encode({
      'username': username,
      'password': password,
    });

    try {
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

  static Future<bool> updateUser(User user, BuildContext context) async {
    final url = Uri.parse('http://localhost:3000/users');
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
}