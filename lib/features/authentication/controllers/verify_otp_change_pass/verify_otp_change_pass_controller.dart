import 'package:dms/features/authentication/screens/change_password/change_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/services/auth_services.dart';
import '../../screens/forgot_password/forgot_password.dart';

class OtpControllerChangePass extends GetxController {
  Future<void> verifyOtpChangePass(String email, String otp) async {
    try {
      final response = await AuthService.verifyOtp(email: email, otpCode: otp);
      Get.snackbar('Thành công', response.content);
      Get.to(() => ChangePasswordScreen());
    } catch (e) {
      Get.snackbar('Lỗi xác thực', e.toString());
    }
  }
}
