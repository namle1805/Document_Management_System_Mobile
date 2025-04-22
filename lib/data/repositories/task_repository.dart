import 'dart:convert';

import 'package:dms/data/services/task_service.dart';

import '../../features/authentication/controllers/user/user_manager.dart';
import '../../features/task/models/task_model.dart';

// class TaskRepository {
//   Future<List<Task>> fetchTasks() async {
//     final userId = UserManager().id;
//     final response = await TaskService.get('Task/view-all-tasks?userId=$userId&page=1&limit=10000');
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final List content = data['content'];
//       return content.map((e) => Task.fromJson(e)).toList();
//     } else {
//       throw Exception('Failed to load tasks');
//     }
//   }
// }

class TaskRepository {
  Future<List<Task>> fetchTasks() async {
    final userId = UserManager().id;
    final token = UserManager().token;

    final response = await TaskService.get(
      'Task/view-all-tasks?userId=$userId&page=1&limit=10000',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List content = data['content'];
      return content.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }
}
