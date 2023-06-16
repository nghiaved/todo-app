import 'dart:convert';
import 'package:client/constants/config.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static registerUser(reqBody) async {
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  static loginUser(reqBody) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  static updateUser(id, reqBody) async {
    final uri = '$updateUrl/$id';
    final response = await http.put(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  static createTodo(reqBody) async {
    final response = await http.post(
      Uri.parse(createTodoUrl),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  static readTodo(id) async {
    final uri = '$readTodoUrl?userId=$id';
    final response = await http.get(
      Uri.parse(uri),
      headers: {'content-type': 'application/json'},
    );
    return response;
  }

  static updateTodo(id, reqBody) async {
    final uri = '$updateTodoUrl/$id';
    final response = await http.put(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  static deleteTodo(id) async {
    final uri = '$deleteTodoUrl/$id';
    final response = await http.delete(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }
}
