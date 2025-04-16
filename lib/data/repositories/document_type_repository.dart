import 'package:dms/data/services/document_service.dart';
import '../../features/authentication/controllers/user/user_manager.dart';
import '../../features/document/models/document_type.dart';

class DocumentTypeRepository {

  // Future<List<DocumentType>> fetchDocumentTypes() async {
  //   final response = await DocumentService().get('/api/Document/view-all-type-documents-mobile');
  //   final List data = response['content'];
  //
  //   return data.map((json) => DocumentType.fromJson(json)).toList();
  // }

  // Future<List<DocumentType>> fetchDocumentTypes() async {
  //   final response = await DocumentService().get(
  //     '/api/Document/view-all-type-documents-mobile',
  //     headers: {
  //       "Authorization": 'Bearer ${UserManager().token}',
  //     },
  //   );
  //   final List data = response['content'];
  //
  //   return data.map((json) => DocumentType.fromJson(json)).toList();
  // }
  Future<List<DocumentType>> fetchDocumentTypes() async {
    final response = await DocumentService().get(
      '/api/Document/view-all-type-documents-mobile',
      headers: {
        "Authorization": 'Bearer ${UserManager().token}'
      },
    );

    if (response == null || response['content'] == null) {
      throw Exception("Response hoặc content null");
    }

    final List data = response['content'];
    return data.map((json) => DocumentType.fromJson(json)).toList();
  }

}
