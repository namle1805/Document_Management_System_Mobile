import 'package:dms/features/authentication/controllers/user/user_manager.dart';
import 'package:dms/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../data/services/notification_service.dart';
import '../../models/notification_model.dart';



class NotificationListPage extends StatefulWidget {
  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  List<NotificationModel> notifications = [];
  bool isLoading = true;
  String formatTime(String createdAt) {
    try {
      return DateFormat.Hm().format(DateTime.parse(createdAt));
    } catch (e) {
      return ''; // hoặc '00:00'
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final notificationService = NotificationService();
      final userId = UserManager().id;
      final newNotifications = await notificationService.getNotifications(userId, 1, 10000);
      setState(() {
        notifications = newNotifications;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle error, show a message or log the error
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      final notificationService = NotificationService();
      await notificationService.markNotificationAsRead(notificationId);
      setState(() {
        notifications = notifications.map((notification) {
          if (notification.id == notificationId) {
            return NotificationModel(
              id: notification.id,
              title: notification.title,
              content: notification.content,
              isRead: true,
              createdAt: notification.createdAt,
              type: notification.type,
              taskId: notification.taskId,
              documentId: notification.documentId,
              workflowId: notification.workflowId,
              redirectUrl: notification.redirectUrl,
            );
          }
          return notification;
        }).toList();
      });
    } catch (error) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.to(() => NavigationMenu()),
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadNotifications,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(UserManager().avatar.toString()),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: notification.isRead ? Colors.grey : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatTime(notification.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            if (!notification.isRead)
                              IconButton(
                                icon: Icon(Icons.mark_email_read),
                                onPressed: () => _markAsRead(notification.id),
                              ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

    );
  }
}
