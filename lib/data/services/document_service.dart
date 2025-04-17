import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../features/authentication/controllers/user/user_manager.dart';
import '../../features/document/models/document_detail.dart';
import '../../features/document/models/document_list.dart';

class DocumentService {
  static const String baseUrl = 'http://nghetrenghetre.xyz:5290';



  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final uri = Uri.parse(baseUrl + url);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Lỗi khi fetch API: ${response.statusCode}");
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

  Future<List<DocumentModel>> fetchDocumentsHome(String documentType) async {
    final response = await http.get(
        Uri.parse("http://nghetrenghetre.xyz:5290/api/Document/view-all-documents-by-document-type-mobile?documentTypeId=$documentType"),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        }
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<List<dynamic>> content = List<List<dynamic>>.from(data['content']);

      // Làm phẳng mảng 2 chiều
      final flattenedList = content.expand((sublist) => sublist).toList();

      return flattenedList.map((e) => DocumentModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load documents: ${response.statusCode}");
    }
  }


  Future<List<DocumentModel>> fetchSearchDocuments(String query) async {
    final response = await http.get(
        Uri.parse("http://nghetrenghetre.xyz:5290/api/Document/view-document-by-name?documentName=$query"),
        headers: {
          "Authorization": 'Bearer ${UserManager().token}'
        }
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> outerList = data['content'];
      final List<DocumentModel> documents = [];

      for (var innerList in outerList) {
        for (var docJson in innerList) {
          documents.add(DocumentModel.fromJson(docJson));
        }
      }
      return documents;
    } else {
      throw Exception('Failed to load documents');
    }
  }



  static Future<DocumentDetail?> fetchDocumentDetail({
    required String documentId,
    required String workFlowId,
  }) async {
    final url = Uri.parse(
      'http://nghetrenghetre.xyz:5290/api/Document/view-detail-documents-mobile'
          '?documentId=$documentId&workFlowId=$workFlowId',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer ${UserManager().token}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final content = jsonData['content'];
        return DocumentDetail.fromJson(content);
      } else {
        print('Lỗi khi fetch document: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Lỗi gọi API: $e');
      return null;
    }
  }
}