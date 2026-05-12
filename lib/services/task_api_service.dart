import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskApiService {
  static const String baseUrl = "https://dummyjson.com";
  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(
      Uri.parse("$baseUrl/todos"),
    );
    if (response.statusCode == 200) {
      final priorities = ["niski", "średni", "wysoki"];
      final data = jsonDecode(response.body);
      final List todos = data["todos"];
      return todos.map((todo) {
        return Task(
            id: Random().nextInt(100000),
            title: todo["todo"],
            deadline: "za ${Random().nextInt(30)+2} dni",
            done: todo["completed"],
            priority: priorities[Random().nextInt(priorities.length)]
        );
      }).toList();
    } else {
      throw Exception("Błąd pobierania danych");
    }
  }
}