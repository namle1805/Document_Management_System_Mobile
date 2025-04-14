class DocumentType {
  final String id;
  final String name;
  final bool isDeleted;

  DocumentType({
    required this.id,
    required this.name,
    required this.isDeleted,
  });

  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(
      id: json['documentTypeId'],
      name: json['documentTypeName'],
      isDeleted: json['isDeleted'],
    );
  }
}
