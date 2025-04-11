// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// // import '../../../../data/services/auth_services.dart';
// //
// // class LoginController extends GetxController {
// //   final emailController = TextEditingController();
// //   final passwordController = TextEditingController();
// //   var isLoading = false.obs;
// //
// //   Future<void> login(String email, String password) async {
// //     isLoading.value = true;
// //     try {
// //       final result = await AuthService.login(
// //         email: email,
// //         password: password,
// //         fcmToken: 'dummy_fcm_token',
// //       );
// //       final user = result['user'];
// //       final token = result['token'];
// //
// //       print('✅ Đăng nhập thành công: ${user.fullName}');
// //       Get.offAllNamed('/navigation');
// //     } catch (e) {
// //       Get.snackbar('Lỗi đăng nhập', e.toString(),
// //           snackPosition: SnackPosition.BOTTOM);
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../data/services/auth_services.dart';
// import '../../../../navigation_menu.dart';
//
// class LoginController extends GetxController {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   var isLoading = false.obs;
//
//   Future<void> login(String email, String password) async {
//     isLoading.value = true;
//     try {
//       final result = await AuthService.login(
//         email: email,
//         password: password,
//         fcmToken: 'dummy_fcm_token',
//       );
//       final user = result['user'];
//       final token = result['token'];
//
//       print('✅ Đăng nhập thành công: ${user.fullName}');
//       Get.offAll(() => NavigationMenu());
//     } catch (e) {
//       Get.snackbar('Lỗi đăng nhập', e.toString(),
//           snackPosition: SnackPosition.BOTTOM);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Hàm trung gian gọi login với dữ liệu nhập từ form
//   void handleLogin() {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       Get.snackbar('Thông báo', 'Vui lòng nhập đầy đủ email và mật khẩu');
//       return;
//     }
//
//     login(email, password);
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/auth_services.dart';
import '../../../../navigation_menu.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final result = await AuthService.login(
        email: email,
        password: password,
        fcmToken: 'dummy_fcm_token',
      );
      final user = result['user'];
      final token = result['token'];

      print('✅ Đăng nhập thành công: ${user.fullName}');
      Get.offAll(() => NavigationMenu());
    } catch (e) {
      Get.snackbar('Lỗi đăng nhập', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void handleLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    login(email, password);
  }
}
