import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';

Future<void> main() async {
  await initializeDateFormatting('vi', null);
  runApp(const App());
}

