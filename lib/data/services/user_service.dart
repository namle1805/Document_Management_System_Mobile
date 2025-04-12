import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../features/authentication/models/user_model.dart';

class UserApi {
  static Future<UserModel> fetchUserDetails(String userId) async {
    final response = await http.get(
      Uri.parse('http://nghetrenghetre.xyz:5290/api/User/view-profile-user?userId=$userId'),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user details');
    }
  }
}
