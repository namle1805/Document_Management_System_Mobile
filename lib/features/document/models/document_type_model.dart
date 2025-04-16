class DocumentTypeModel {
  final String documentTypeId;
  final String documentTypeName;
  final double percent;

  DocumentTypeModel({
    required this.documentTypeId,
    required this.documentTypeName,
    required this.percent,
  });

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeModel(
      documentTypeId: json['documentTypeId'],
      documentTypeName: json['documentTypeName'],
      percent: (json['percent'] ?? 0).toDouble(),
    );
  }
}

class Workflow {
  final String? workFlowId;
  final String workFlowName;
  final List<DocumentTypeModel> documentTypes;

  Workflow({
     this.workFlowId,
    required this.workFlowName,
    required this.documentTypes,
  });

  factory Workflow.fromJson(Map<String, dynamic> json) {
    var list = json['documentTypes'] as List;
    List<DocumentTypeModel> docTypes = list.map((e) => DocumentTypeModel.fromJson(e)).toList();
    return Workflow(
      workFlowId: json['workFlowId'],
      workFlowName: json['workFlowName'] ?? '',
      documentTypes: docTypes,
    );
  }
}
