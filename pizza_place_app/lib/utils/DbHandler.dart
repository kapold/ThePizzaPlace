import 'dart:convert';
import 'package:http/http.dart' as http;
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

  static Future<void> addUser(User user) async {
    final url = Uri.parse('http://localhost:3000/users');
    final headers = { 'Content-Type': 'application/json' };
    final body = json.encode({
      'username': user.username,
      'password': user.password,
      'phoneNumber': user.phoneNumber,
      'birthday': user.birthday
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode != 201) {
      throw Exception('Failed to add User.');
    }
  }
}