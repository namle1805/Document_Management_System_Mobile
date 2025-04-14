import 'package:http/http.dart' as http;
import 'dart:convert';

class DocumentService {
  static const String baseUrl = 'http://nghetrenghetre.xyz:5290';

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Lỗi khi gọi API: ${response.statusCode}');
    }
  }
}