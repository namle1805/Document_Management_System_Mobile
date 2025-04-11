// import 'package:dms/data/services/auth_services.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class VerifyEmailController extends GetxController {
//   var isLoading = false.obs;
//
//   Future<void> sendOtp(String email) async {
//     isLoading.value = true;
//     try {
//       final response = await AuthService.sendOtp(
//         '/api/Authentication/create-send-otp?email=$email',
//         {"email": email},
//       );
//
//       if (response.statusCode == 201) {
//         final data = SendOtpResponse.fromJson(
//             Map<String, dynamic>.from(await Future.value(response.body).then((e) => e != null ? jsonDecode(e) : {})));
//
//         Get.snackbar("Thành công", data.content,
//             backgroundColor: Colors.green, colorText: Colors.white);
//         // TODO: Navigate đến màn hình nhập OTP nếu cần
//       } else {
//         Get.snackbar("Lỗi", "Gửi OTP thất bại",
//             backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       Get.snackbar("Lỗi", "Đã xảy ra lỗi",
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
