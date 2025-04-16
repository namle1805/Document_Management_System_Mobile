class DocumentType {
  final String id;
  final String name;
  final double percent;
  final bool? documentResponseMobiles;

  DocumentType({
    required this.id,
    required this.name,
    required this.percent,
     this.documentResponseMobiles,
  });

  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(
      id: json['documentTypeId'],
      name: json['documentTypeName'],
      percent: (json['percent'] as num).toDouble(),
      documentResponseMobiles: json['documentResponseMobiles'] == null
          ? null
          : json['documentResponseMobiles'] as bool,
    );
  }
}
