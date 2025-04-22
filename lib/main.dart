import 'package:dms/Service/notification_service.dart';
import 'package:dms/api/firebase_api.dart';
import 'package:dms/data/services/notification_service.dart';
import 'package:dms/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  await FirebaseApi().initNotification();
  await initializeDateFormatting('vi', null);
  runApp(const App());
}

