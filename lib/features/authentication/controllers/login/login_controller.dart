import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/auth_services.dart';
import '../../../../navigation_menu.dart';
import '../../models/login_response.dart';
import '../user/user_manager.dart';

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
        fcmToken: 'string',
      );

      final user = result['user'] as UserDto;
      final token = result['token'] as String;

      // 👉 Lưu thông tin user và token vào UserManager
      UserManager().setUser(user, token);

      print('✅ Đăng nhập thành công: ${UserManager().name}');
      print('Token: ${UserManager().token}');

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
