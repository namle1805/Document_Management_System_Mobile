import 'package:dms/Service/notification_service.dart';
import 'package:dms/api/firebase_api.dart';
import 'package:dms/data/services/notification_service.dart';
import 'package:dms/features/authentication/controllers/user/user_manager.dart';
import 'package:dms/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';

RemoteMessage? initialMessage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  await UserManager().loadFromStorage();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  print('--- Init Firebase ---');

  initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  await FirebaseApi().initNotification();
  print('--- Done Firebase ---');
  await initializeDateFormatting('vi', null);
  runApp(App(isLoggedIn: isLoggedIn));
}

