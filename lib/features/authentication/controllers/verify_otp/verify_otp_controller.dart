import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/services/auth_services.dart';
import '../../screens/forgot_password/forgot_password.dart';

class OtpController extends GetxController {
  Future<void> verifyOtp(String email, String otp) async {
    try {
      final response = await AuthService.verifyOtp(email: email, otpCode: otp);
      Get.snackbar('Thành công', response.content);
      Get.to(() => ForgotPasswordScreen());
    } catch (e) {
      Get.snackbar('Lỗi xác thực', e.toString());
    }
  }
}
