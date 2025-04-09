import 'package:dms/features/authentication/screens/login/login.dart';
import 'package:dms/features/document/screens/document_type_list/document_type_list.dart';
import 'package:dms/features/document/screens/home/home.dart';
import 'package:dms/features/document/screens/notification/notification_list.dart';
import 'package:dms/features/task/screens/task_list/task_list.dart';
import 'package:dms/utils/constants/colors.dart';
import 'package:dms/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
            () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.black : Colors.white,
          indicatorColor: darkMode ? TColors.white.withOpacity(0.1) : TColors.black.withOpacity(0.1),

          destinations: const[
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Trang Chủ'),
            NavigationDestination(icon: Icon(Iconsax.notification), label: 'Thông Báo'),
            NavigationDestination(icon: Icon(Iconsax.book), label: 'Nhiệm Vụ'),
            NavigationDestination(icon: Icon(Iconsax.folder), label: 'Loại văn bản'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [  HomePage(), NotificationListPage(), TaskListPage(), DocumentTypeListPage()];
}