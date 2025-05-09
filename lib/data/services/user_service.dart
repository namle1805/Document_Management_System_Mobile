import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../features/authentication/controllers/user/user_manager.dart';
import '../../features/authentication/models/user_model.dart';

class UserApi {
  static Future<UserModel> fetchUserDetails(String userId) async {
    final response = await http.get(
      Uri.parse('https://www.signdoc-core.io.vn/api/User/view-profile-user?userId=$userId'),
        headers: {
          'Authorization': 'Bearer ${UserManager().token}',
        }
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user details');
    }
  }


  static Future<String?> uploadAvatar(File file, String userId) async {
    final uri = Uri.parse("https://www.signdoc-core.io.vn/api/User/update-avatar/$userId");
    var request = http.MultipartRequest('POST', uri,);
    request.headers['Authorization'] = 'Bearer ${UserManager().token}';

    request.fields['userId'] = userId;


    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType('image', 'jpeg'), // hoặc 'image/png' nếu cần
    ));

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final json = jsonDecode(responseBody);
      return json['content'];
    } else {
      print('Upload avatar failed with status: ${response.statusCode}');
      return null;
    }
  }

  static Future<bool> updateUser({
    required String userId,
    required String address,
    required String dateOfBirth,
    required String gender,
    required String avatarUrl,
  }) async {
    final uri = Uri.parse("https://www.signdoc-core.io.vn/api/User/update-user");

    final body = jsonEncode({
      "userId": userId,
      "address": address,
      "dateOfBirth": dateOfBirth,
      "gender": gender.toUpperCase(), // "MALE" or "FEMALE"
      "avatar": avatarUrl
    });

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserManager().token}', // Thêm Authorization header
      },
      body: body,
    );

    return response.statusCode == 200;
  }

}
