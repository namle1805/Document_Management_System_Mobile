class DocumentModel {
  final String? id;
  final String? documentName;
  final DateTime createdDate;
  final String? size;

  DocumentModel({
     this.id,
     this.documentName,
    required this.createdDate,
    this.size,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      documentName: json['documentName'],
      createdDate: DateTime.parse(json['createdDate']),
      size: json['size'],
    );
  }
}
