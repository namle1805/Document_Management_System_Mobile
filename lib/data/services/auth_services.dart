// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../features/authentication/models/login_response.dart';
//
//
// class AuthService {
//   static Future<Map<String, dynamic>> login({
//     required String email,
//     required String password,
//     required String fcmToken,
//   }) async {
//     final url = Uri.parse('http://nghetrenghetre.xyz:5290/api/Authentication/view-sign-in');
//
//     final body = jsonEncode({
//       'email': email,
//       'password': password,
//       'fcmToken': fcmToken,
//     });
//
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: body,
//     );
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//
//       if (data['statusCode'] == 201) {
//         final userJson = data['content']['userDto'];
//         final token = data['content']['token'];
//         return {
//           'user': UserDto.fromJson(userJson),
//           'token': token,
//         };
//       } else {
//         throw Exception('Đăng nhập thất bại: ${data['message']}');
//       }
//     } else {
//       throw Exception('Đăng nhập thất bại: ${response.statusCode}');
//     }
//   }
//
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/authentication/models/login_response.dart';
import '../../features/authentication/models/verify_otp_response.dart';

class AuthService {
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    final url = Uri.parse('http://nghetrenghetre.xyz:5290/api/Authentication/view-sign-in');

    final body = jsonEncode({
      'email': email,
      'password': password,
      'fcmToken': fcmToken,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      if (data['statusCode'] == 201) {
        final userJson = data['content']['userDto'];
        final token = data['content']['token'];
        return {
          'user': UserDto.fromJson(userJson),
          'token': token,
        };
      } else {
        throw Exception('Đăng nhập thất bại: ${data['message']}');
      }
    } else {
      throw Exception('Đăng nhập thất bại: ${response.statusCode}');
    }
  }

  static Future<void> sendOtp({required String email}) async {
    final url = Uri.parse('http://nghetrenghetre.xyz:5290/api/Authentication/create-send-otp?email=$email');

    final body = jsonEncode({'email': email});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      if (data['statusCode'] == 201) {
        print('✅ OTP sent successfully');
      } else {
        throw Exception('Gửi OTP thất bại: ${data['message']}');
      }
    } else {
      throw Exception('Gửi OTP thất bại: ${response.statusCode}');
    }
  }


  static Future<VerifyOtpResponse> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    final url = Uri.parse('http://nghetrenghetre.xyz:5290/api/Authentication/create-verify-otp');

    final body = jsonEncode({
      'email': email,
      'otpCode': otpCode,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    final data = jsonDecode(response.body);
    // if (response.statusCode == 201 && data['statusCode'] == 201) {
    //   return VerifyOtpResponse.fromJson(data);
    // } else {
    //   throw Exception(data['message'] ?? 'OTP verification failed');
    // }
    if (response.statusCode == 200 || response.statusCode == 201) {
      return VerifyOtpResponse.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'OTP verification failed');
    }

  }
}
