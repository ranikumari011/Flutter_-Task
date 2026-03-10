import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskService {

  static const String baseUrl =
      "https://fir-storge-de5cb-default-rtdb.asia-southeast1.firebasedatabase.app/tasks";

  /// ADD TASK
  static Future<bool> addTask(String title, String description) async {

    final response = await http.post(
      Uri.parse("$baseUrl.json"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "isCompleted": false,
        "createdAt": DateTime.now().toString()
      }),
    );

    return response.statusCode == 200;
  }

  /// GET TASKS
  static Future<List<Map<String, dynamic>>> getTasks() async {

    final response = await http.get(Uri.parse("$baseUrl.json"));

    final data = jsonDecode(response.body);

    if (data == null) return [];

    List<Map<String, dynamic>> tasks = [];

    data.forEach((key, value) {

      tasks.add({
        "id": key,
        "title": value["title"],
        "description": value["description"],
        "isCompleted": value["isCompleted"] ?? false,
      });

    });

    return tasks;
  }

  /// UPDATE TASK
  static Future<bool> updateTask(
      String id,
      String title,
      String description,
      ) async {

    final response = await http.patch(
      Uri.parse("$baseUrl/$id.json"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
      }),
    );

    return response.statusCode == 200;
  }

  /// DELETE TASK
  static Future<bool> deleteTask(String id) async {

    final response = await http.delete(
      Uri.parse("$baseUrl/$id.json"),
    );

    return response.statusCode == 200;
  }

  /// TOGGLE COMPLETE
  static Future<bool> toggleTask(String id, bool value) async {

    final response = await http.patch(
      Uri.parse("$baseUrl/$id.json"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "isCompleted": value
      }),
    );

    return response.statusCode == 200;
  }

}