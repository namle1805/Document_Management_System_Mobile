class DocumentDetail {
  final String? documentId;
  final String? documentName;
  final String? documentContent;
  final String? numberOfDocument;
  final String? processingStatus;
  final String? dateIssued;
  final String? documentTypeName;
  final String? createdDate;
  final String? createdBy;
  final List<String> divisionList;
  final List<UserInfo> userList;
  final List<String>? signBys;
  final String documentUrl;
  final List<SizeInfo> sizes;

  DocumentDetail({
    this.documentId,
    this.documentName,
    this.documentContent,
    this.numberOfDocument,
    this.processingStatus,
    this.dateIssued,
    this.documentTypeName,
    this.createdDate,
    this.createdBy,
    required this.divisionList,
    required this.userList,
    this.signBys,
    required this.documentUrl,
    required this.sizes,
  });

  factory DocumentDetail.fromJson(Map<String, dynamic> json) {
    return DocumentDetail(
      documentId: json['documentId'],
      documentName: json['documentName'],
      documentContent: json['documentContent'],
      numberOfDocument: json['numberOfDocument'],
      processingStatus: json['processingStatus'],
      dateIssued: json['dateIssued'],
      documentTypeName: json['documentTypeName'],
      createdDate: json['createdDate'],
      createdBy: json['createdBy'],
      divisionList: List<String>.from(json['divisionList'] ?? []),
      userList: List<UserInfo>.from(
        (json['userList'] ?? []).map((x) => UserInfo.fromJson(x)),
      ),
      signBys: (json['signBys'] as List?)?.map((e) => e.toString()).toList(),
      documentUrl: json['documentUrl'],
      sizes: List<SizeInfo>.from(
        (json['sizes'] ?? []).map((x) => SizeInfo.fromJson(x)),
      ),
    );
  }
}



class SizeInfo {
  final double width;
  final double height;
  final int page;

  SizeInfo({
    required this.width,
    required this.height,
    required this.page,
  });

  factory SizeInfo.fromJson(Map<String, dynamic> json) {
    return SizeInfo(
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      page: json['page'],
    );
  }
}


class UserInfo {
  final String userId;
  final String fullName;
  final String divisionName;

  UserInfo({
    required this.userId,
    required this.fullName,
    required this.divisionName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'],
      fullName: json['fullName'],
      divisionName: json['divisionName'],
    );
  }
}
