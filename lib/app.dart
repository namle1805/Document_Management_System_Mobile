import 'package:dms/api/firebase_api.dart';
import 'package:dms/features/authentication/screens/onboarding/onboarding.dart';
import 'package:dms/main.dart';
import 'package:dms/navigation_menu.dart';
import 'package:dms/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;
  const App({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final isNavigating = ValueNotifier(true);
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialRoute: isLoggedIn ? '/home' : '/login',
      getPages: [
        GetPage(name: '/login', page: () => const OnBoardingScreen()),
        GetPage(name: '/home', page: () => NavigationMenu()),
        // thêm các route khác nếu có
      ],
      builder: (context, child) {
        // ✅ Chờ sau khi build xong rồi mới xử lý điều hướng
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (initialMessage != null) {
            FirebaseApi.handleInitialMessage(initialMessage!);
            initialMessage = null;
          }
        });
        return child!;
      },
      //home: const OnBoardingScreen(),
    );
  }
}
