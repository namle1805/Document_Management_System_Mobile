import 'package:dms/data/services/document_service.dart';
import '../../features/document/models/document_type.dart';

class DocumentTypeRepository {
  final DocumentService _apiService = DocumentService();

  Future<List<DocumentType>> fetchDocumentTypes() async {
    final response = await _apiService.get('/api/DocumentType/view-all-document-type?page=1&limit=10000');
    final List data = response['content'];

    return data.map((json) => DocumentType.fromJson(json)).toList();
  }
}
