import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../../features/authentication/controllers/user/user_manager.dart';
import '../../features/document/models/notification_model.dart';

class NotificationService {
  static const String baseUrl = 'http://nghetrenghetre.xyz:5290/api/Notification/';
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

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



  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static void showNotification({required String title, required String body}) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      channelDescription: 'This channel is used for default notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    _notificationsPlugin.show(0, title, body, notificationDetails);
  }
}
