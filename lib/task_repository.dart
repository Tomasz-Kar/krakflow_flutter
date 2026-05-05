import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class Task {
  final String title;
  final String deadline;
  final String priority;
  bool done;

  Task({required this.title, required this.deadline, required this.priority, required this.done});
}

class TaskApiService {
  static const String baseUrl = "https://dummyjson.com";
  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(
      Uri.parse("$baseUrl/todos"),
    );
    if (response.statusCode == 200) {
      final random = Random();
      final priorities = ["niski", "średni", "wysoki"];
      final data = jsonDecode(response.body);
      final List todos = data["todos"];
      return todos.map((todo) {
        return Task(
          title: todo["todo"],
          deadline: "za ${random.nextInt(30)+2} dni",
          done: todo["completed"],
          priority: priorities[random.nextInt(priorities.length)]
        );
      }).toList();
    } else {
      throw Exception("Błąd pobierania danych");
    }
  }
}


class TaskRepository {
  static List<Task> tasks = [];
  /*static Future<void> loadTasksFromServer() async {
    tasks = await TaskApiService.fetchTasks();
  }*/
}