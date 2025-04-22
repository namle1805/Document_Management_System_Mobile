import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../features/authentication/controllers/user/user_manager.dart';
import '../../features/task/models/task_detail.dart';

class TaskService {
  static const String baseUrl = 'http://nghetrenghetre.xyz:5290/api';

  static Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(url, headers: headers);
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
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${UserManager().token}',
      });

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
