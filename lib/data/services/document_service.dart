import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../features/authentication/controllers/user/user_manager.dart';
import '../../features/document/models/document_list.dart';
import '../../features/document/models/document_type.dart';
import '../../features/document/models/document_type_model.dart';

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

  Future<List<DocumentModel>> fetchDocuments(String workFlowId, String documentTypeId) async {

    final response = await http.get(
        Uri.parse("http://nghetrenghetre.xyz:5290/api/Document/view-all-documents-mobile?workFlowId=$workFlowId&documentTypeId=$documentTypeId"),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        }
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List content = data['content'];
      return content.map((e) => DocumentModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load documents: ${response.statusCode}");
    }
  }
}