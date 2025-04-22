import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/authentication/controllers/user/user_manager.dart';
import '../../features/document/models/notification_model.dart';

class NotificationService {
  static const String baseUrl = 'http://nghetrenghetre.xyz:5290/api/Notification/';

  // Lấy danh sách thông báo
  Future<List<NotificationModel>> getNotifications(String userId, int page, int limit) async {
    final url = Uri.parse('http://nghetrenghetre.xyz:5290/api/Notification/view-notifications-by-user-id?userId=$userId&page=$page&limit=$limit');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${UserManager().token}',
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final content = responseBody['content'] as List;
      return content.map((notification) => NotificationModel.fromJson(notification)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  // Đánh dấu thông báo là đã đọc
  Future<void> markNotificationAsRead(String notificationId) async {
    final url = Uri.parse('http://nghetrenghetre.xyz:5290/api/Notification/update-mark-notification-as-read?notificationId=$notificationId');

    final response = await http.post(url, headers: {
      'Authorization': 'Bearer ${UserManager().token}',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }
}
