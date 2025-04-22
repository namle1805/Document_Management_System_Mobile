import 'dart:convert';

import 'package:dms/utils/token_manager/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/auth_services.dart';
import '../../../../navigation_menu.dart';
import '../../models/login_response.dart';
import '../user/user_manager.dart';
//
// class LoginController extends GetxController {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   var isLoading = false.obs;
//   var isPasswordHidden = true.obs;
//
//   void togglePasswordVisibility() {
//     isPasswordHidden.value = !isPasswordHidden.value;
//   }
//
//   Future<void> login(String email, String password) async {
//     isLoading.value = true;
//     try {
//       final result = await AuthService.login(
//         email: email,
//         password: password,
//         fcmToken: 'string',
//       );
//
//       final user = result['user'] as UserDto;
//       final token = result['token'] as String;
//
//       // 👉 Lưu thông tin user và token vào UserManager
//       UserManager().setUser(user, token);
//
//       print('✅ Đăng nhập thành công: ${UserManager().name}');
//       print('Token: ${UserManager().token}');
//
//       Get.offAll(() => NavigationMenu());
//     } catch (e) {
//       Get.snackbar('Lỗi đăng nhập', e.toString(),
//           snackPosition: SnackPosition.BOTTOM);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//
//   void handleLogin() {
//     final email = emailController.text.trim();
//     final password = passwordController.text;
//     login(email, password);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isRememberMe = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe(bool? value) {
    isRememberMe.value = value ?? false;
  }

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    final remember = prefs.getBool('rememberMe') ?? false;

    if (remember) {
      emailController.text = savedEmail ?? '';
      passwordController.text = savedPassword ?? '';
      isRememberMe.value = true;
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      String fcmToken = TokenManager().fcmToken!;
      final result = await AuthService.login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );

      final user = result['user'] as UserDto;
      final token = result['token'] as String;

      /// Lưu thông tin user vào UserManager
      UserManager().setUser(user, token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('token', token);
      final userJson = jsonEncode(user);
      await prefs.setString('user', userJson);
      /// Lưu hoặc xóa thông tin đăng nhập dựa trên checkbox
      //final prefs = await SharedPreferences.getInstance();
      if (isRememberMe.value) {
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setBool('rememberMe', true);
      } else {
        await prefs.remove('email');
        await prefs.remove('password');
        await prefs.setBool('rememberMe', false);
      }

      print('✅ Đăng nhập thành công: ${UserManager().name}');
      print('Token: ${UserManager().token}');
      print('fcmToken: ${fcmToken}');

      Get.offAll(() => NavigationMenu());
    } catch (e) {
      Get.snackbar('Lỗi đăng nhập', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> saveLoginStatus(String token) async {

  }

  void handleLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    login(email, password);
  }
}

