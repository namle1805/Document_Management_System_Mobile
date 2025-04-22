import 'package:dms/Service/notification_service.dart';
import 'package:dms/data/services/notification_service.dart';
import 'package:dms/utils/token_manager/token_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessageing = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessageing.requestPermission();

    final fCMToken = await _firebaseMessageing.getToken();


    TokenManager().fcmToken = fCMToken;

    print('Token: $fCMToken');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        NotificationService.showNotification(
          title: notification.title ?? 'Thông báo',
          body: notification.body ?? '',
        );
      }
    });
  }
}