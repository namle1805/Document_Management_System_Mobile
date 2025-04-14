import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../features/task/models/task_detail.dart';

class TaskService {
  static const String baseUrl = 'http://nghetrenghetre.xyz:5290/api';

  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(url);
  }


  // static Future<TaskDetail?> fetchTaskDetail(String taskId) async {
  //   final url = Uri.parse('http://nghetrenghetre.xyz:5290/api/Task/view-task-by-id?id=$taskId');
  //
  //   try {
  //     final response = await http.get(url);
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final taskJson = data['content'];
  //       return TaskDetail.fromJson(taskJson);
  //     } else {
  //       print('Failed to load task: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     return null;
  //   }
  // }

  static Future<TaskContent?> fetchTaskDetail(String taskId) async {
    final url = Uri.parse('http://nghetrenghetre.xyz:5290/api/Task/view-task-by-id?id=$taskId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final contentJson = data['content'];
        return TaskContent.fromJson(contentJson);
      } else {
        print('Failed to load task: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

}
