import 'dart:convert';
import 'package:dms/features/authentication/screens/login/login.dart';
import 'package:dms/features/document/screens/document_detail/document_detail.dart';
import 'package:dms/features/task/screens/task_detail/task_detail.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/authentication/controllers/user/user_manager.dart';
import '../../features/document/models/notification_model.dart';
import 'package:get/get.dart';

class NotificationService {
  static const String baseUrl = 'http://103.90.227.64:5290/api/Notification/';
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Lấy danh sách thông báo
  Future<List<NotificationModel>> getNotifications(String userId, int page, int limit) async {
    final url = Uri.parse('http://103.90.227.64:5290/api/Notification/view-notifications-by-user-id?userId=$userId&page=$page&limit=$limit');

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
    final url = Uri.parse('http://103.90.227.64:5290/api/Notification/update-mark-notification-as-read?notificationId=$notificationId');

    final response = await http.post(url, headers: {
      'Authorization': 'Bearer ${UserManager().token}',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }



  // static Future<void> init() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //   AndroidInitializationSettings('@mipmap/ic_launcher');
  //
  //   const InitializationSettings initializationSettings =
  //   InitializationSettings(android: initializationSettingsAndroid);
  //
  //   await _notificationsPlugin.initialize(initializationSettings);
  // }
  //
  // static void showNotification({required String title, required String body}) {
  //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //     'default_channel_id',
  //     'Default Channel',
  //     channelDescription: 'This channel is used for default notifications.',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //
  //   const NotificationDetails notificationDetails =
  //   NotificationDetails(android: androidDetails);
  //
  //   _notificationsPlugin.show(0, title, body, notificationDetails);
  // }

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;
        if (payload == null) return;

        final data = Uri.splitQueryString(payload);
        final type = data['type'];
        final prefs = await SharedPreferences.getInstance();

        if (type.toString().toLowerCase() == 'document' && data['documentId'] != null && data['workflowId'] != null) {
          if (UserManager().token == null || prefs.getString('token') == null){
            Get.to(() => LoginScreen());
          }else{
            Get.to(() => DocumentDetailPage(
              documentId: data['documentId']!,
              workFlowId: data['workflowId']!, sizes: [], size: '', date: '', taskId: '', taskType: '', isUsb: null!,
            ));
          }

        } else if (type.toString().toLowerCase() == 'task' && data['taskId'] != null) {
          if (UserManager().token == null || prefs.getString('token') == null){
            Get.to(() => LoginScreen());
          }else{
            Get.to(() => TaskDetailPage(taskId: data['taskId']!));
          }

        } else {
          Get.snackbar('Không hợp lệ', 'Không thể điều hướng thông báo này');
        }
      },
    );
  }

  static void showNotification({
    required String title,
    required String body,
    required Map<String, String> data, // chứa type, documentId, workflowId hoặc taskId
  }) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      channelDescription: 'This channel is used for default notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    // encode data to query string for payload
    final payload = Uri(queryParameters: data).query;
    print('--- Show notification with payload: $payload ---');
    _notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

}
