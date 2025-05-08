// class DocumentDetail {
//   final String? documentId;
//   final String? documentName;
//   final String? documentContent;
//   final String? numberOfDocument;
//   final String? processingStatus;
//   final String? dateIssued;
//   final String? documentTypeName;
//   final String? createdDate;
//   final String? createdBy;
//   final String? receiver;
//   final String? sender;
//   final List<String> divisionList;
//   final List<UserInfo> userList;
//   final List<String>? signBys;
//   final List<String>? viewerList;
//   final List<String>? granterList;
//   final String documentUrl;
//   final List<SizeInfo> sizes;
//
//   DocumentDetail({
//     this.documentId,
//     this.documentName,
//     this.documentContent,
//     this.numberOfDocument,
//     this.processingStatus,
//     this.dateIssued,
//     this.documentTypeName,
//     this.createdDate,
//     this.createdBy,
//     this.sender,
//     this.receiver,
//     required this.divisionList,
//     required this.userList,
//     this.signBys,
//     this.viewerList,
//     this.granterList,
//     required this.documentUrl,
//     required this.sizes,
//   });
//
//   factory DocumentDetail.fromJson(Map<String, dynamic> json) {
//     return DocumentDetail(
//       documentId: json['documentId'],
//       documentName: json['documentName'],
//       documentContent: json['documentContent'],
//       numberOfDocument: json['numberOfDocument'],
//       processingStatus: json['processingStatus'],
//       dateIssued: json['dateIssued'],
//       documentTypeName: json['documentTypeName'],
//       createdDate: json['createdDate'],
//       createdBy: json['createdBy'],
//       sender: json['sender'],
//       receiver: json['receiver'],
//       divisionList: List<String>.from(json['divisionList'] ?? []),
//       userList: List<UserInfo>.from(
//         (json['userList'] ?? []).map((x) => UserInfo.fromJson(x)),
//       ),
//       signBys: (json['signBys'] as List?)?.map((e) => e.toString()).toList(),
//       viewerList: (json['viewerList'] as List?)?.map((e) => e.toString()).toList(),
//       granterList: (json['granterList'] as List?)?.map((e) => e.toString()).toList(),
//       documentUrl: json['documentUrl'],
//       sizes: List<SizeInfo>.from(
//         (json['sizes'] ?? []).map((x) => SizeInfo.fromJson(x)),
//       ),
//     );
//   }
// }
//
//
//
// class SizeInfo {
//   final double width;
//   final double height;
//   final int page;
//
//   SizeInfo({
//     required this.width,
//     required this.height,
//     required this.page,
//   });
//
//   factory SizeInfo.fromJson(Map<String, dynamic> json) {
//     return SizeInfo(
//       width: (json['width'] as num).toDouble(),
//       height: (json['height'] as num).toDouble(),
//       page: json['page'],
//     );
//   }
// }
//
//
// class UserInfo {
//   final String userId;
//   final String fullName;
//   final String divisionName;
//
//   UserInfo({
//     required this.userId,
//     required this.fullName,
//     required this.divisionName,
//   });
//
//   factory UserInfo.fromJson(Map<String, dynamic> json) {
//     return UserInfo(
//       userId: json['userId'],
//       fullName: json['fullName'],
//       divisionName: json['divisionName'],
//     );
//   }
// }


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
  final List<ViewerInfo>? viewerList;
  final List<GranterInfo>? granterList;
  final List<ApproverInfo>? approveByList;
  final String documentUrl;
  final List<SizeInfo> sizes;
  final String? receiver;
  final String? sender;
  final String? dateExpired;
  final String? deadline;
  final String? workFlowName;
  final String? scope;
  final String? systemNumberDocument;

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
    this.viewerList,
    this.granterList,
    this.approveByList,
    required this.documentUrl,
    required this.sizes,
    this.receiver,
    this.sender,
    this.dateExpired,
    this.deadline,
    this.workFlowName,
    this.scope,
    this.systemNumberDocument,
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
      viewerList: (json['viewerList'] as List?)
          ?.map((x) => ViewerInfo.fromJson(x))
          .toList(),
      granterList: (json['granterList'] as List?)
          ?.map((x) => GranterInfo.fromJson(x))
          .toList(),
      approveByList: (json['approveByList'] as List?)
          ?.map((x) => ApproverInfo.fromJson(x))
          .toList(),
      documentUrl: json['documentUrl'],
      sizes: List<SizeInfo>.from(
        (json['sizes'] ?? []).map((x) => SizeInfo.fromJson(x)),
      ),
      receiver: json['receiver'],
      sender: json['sender'],
      dateExpired: json['dateExpired'],
      deadline: json['deadline'],
      workFlowName: json['workFlowName'],
      scope: json['scope'],
      systemNumberDocument: json['systemNumberDocument'],
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
  final String? avatar;
  final String divisionName;

  UserInfo({
    required this.userId,
    required this.fullName,
     this.avatar,
     required this.divisionName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'],
      fullName: json['fullName'],
      avatar: json['avatar'],
      divisionName: json['divisionName'],
    );
  }
}
class GranterInfo {
  final String userId;
  final String fullName;
  final String userName;
  final String avatar;
  final String? divisionName;

  GranterInfo({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.avatar,
    this.divisionName,
  });

  factory GranterInfo.fromJson(Map<String, dynamic> json) {
    return GranterInfo(
      userId: json['userId'],
      fullName: json['fullName'],
      userName: json['userName'],
      avatar: json['avatar'] ?? '',
      divisionName: json['divisionName'],
    );
  }
}

class ViewerInfo {
  final String userId;
  final String fullName;
  final String userName;
  final String avatar;
  final String? divisionName;

  ViewerInfo({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.avatar,
    this.divisionName,
  });

  factory ViewerInfo.fromJson(Map<String, dynamic> json) {
    return ViewerInfo(
      userId: json['userId'],
      fullName: json['fullName'],
      userName: json['userName'],
      avatar: json['avatar'] ?? '',
      divisionName: json['divisionName'],
    );
  }
}


class ApproverInfo {
  final String userId;
  final String fullName;
  final String userName;
  final String avatar;
  final String? divisionName;

  ApproverInfo({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.avatar,
    this.divisionName,
  });

  factory ApproverInfo.fromJson(Map<String, dynamic> json) {
    return ApproverInfo(
      userId: json['userId'],
      fullName: json['fullName'],
      userName: json['userName'],
      avatar: json['avatar'] ?? '',
      divisionName: json['divisionName'],
    );
  }
}

