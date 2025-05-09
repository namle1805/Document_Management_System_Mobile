class DocumentType {
  final String id;
  final String name;
  final double percent;
  final int sumDoc;

  DocumentType({
    required this.id,
    required this.name,
    required this.percent,
    required this.sumDoc,
  });

  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(
      id: json['documentTypeId'],
      name: json['documentTypeName'],
      percent: (json['percent'] as num).toDouble(),
      sumDoc: json['sumDoc'] ?? 0,
    );
  }
}
