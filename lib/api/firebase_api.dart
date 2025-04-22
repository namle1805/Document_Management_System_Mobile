import 'package:dms/Service/notification_service.dart';
import 'package:dms/data/services/notification_service.dart';
import 'package:dms/features/authentication/controllers/user/user_manager.dart';
import 'package:dms/features/authentication/screens/login/login.dart';
import 'package:dms/features/document/screens/document_detail/document_detail.dart';
import 'package:dms/features/task/screens/task_detail/task_detail.dart';
import 'package:dms/main.dart';
import 'package:dms/utils/token_manager/token_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseApi {
  final _firebaseMessageing = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessageing.requestPermission();

    final fCMToken = await _firebaseMessageing.getToken();


    TokenManager().fcmToken = fCMToken;

    print('Token: $fCMToken');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final data = message.data;

      if (notification != null) {
        NotificationService.showNotification(
          title: notification.title ?? 'Thông báo',
          body: notification.body ?? '',
          data: {
            'type': data['type'] ?? '',
            'documentId': data['documentId'] ?? '',
            'workflowId': data['workflowId'] ?? '',
            'taskId': data['taskId'] ?? '',
          },
        );
      }
    });

    // Khi app đang chạy ở background và user nhấn vào thông báo
    FirebaseMessaging.onMessageOpenedApp.listen(handleInitialMessage);

    // Khi app khởi động từ notification (tắt hẳn và mở bằng thông báo)
    // final initialMessage = await _firebaseMessageing.getInitialMessage();
    // if (initialMessage != null) {
    //   handleInitialMessage(initialMessage!);
    // }
  }

  static void handleInitialMessage(RemoteMessage message) async{
    final data = message.data;

    final type = data['type'];
    final documentId = data['documentId'];
    final workflowId = data['workflowId'];
    final taskId = data['taskId'];
    final prefs = await SharedPreferences.getInstance();

    if (type.toString().toLowerCase() == 'document' && documentId != null && workflowId != null) {
      if (UserManager().token == null || prefs.getString('token') == null){
        Get.to(() => LoginScreen());
      }else{
        Get.to(() => DocumentDetailPage(
          documentId: documentId,
          workFlowId: workflowId,
        ));
      }

    } else if (type.toString().toLowerCase() == 'task' && taskId != null) {
      if (UserManager().token == null || prefs.getString('token') == null){
        Get.to(() => LoginScreen());
      }else{
        Get.to(() => TaskDetailPage(taskId: taskId));
      }

    } else {
      Get.snackbar('Không hỗ trợ', 'Loại thông báo không xác định hoặc thiếu dữ liệu');
    }
  }

  void _handleMessage(RemoteMessage message) async {
    final data = message.data;

    final type = data['type'];
    final documentId = data['documentId'];
    final workflowId = data['workflowId'];
    final taskId = data['taskId'];


    if (type.toString().toLowerCase() == 'document' && documentId != null && workflowId != null) {
      Get.to(() => DocumentDetailPage(
        documentId: documentId,
        workFlowId: workflowId,
      ));
    } else if (type.toString().toLowerCase() == 'task' && taskId != null) {
      Get.to(() => TaskDetailPage(taskId: taskId));
    } else {
      Get.snackbar('Không hỗ trợ', 'Loại thông báo không xác định hoặc thiếu dữ liệu');
    }
  }
}