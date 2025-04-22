class RoleDto {
  final String roleId;
  final String roleName;
  final String? createdDate;

  RoleDto({
    required this.roleId,
    required this.roleName,
    this.createdDate,
  });

  factory RoleDto.fromJson(Map<String, dynamic> json) {
    return RoleDto(
      roleId: json['roleId'],
      roleName: json['roleName'],
      createdDate: json['createdDate'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'roleId': roleId,
      'roleName': roleName,
      'createdDate': createdDate,
    };
  }
}

class DivisionDto {
  final String divisionId;
  final String divisionName;
  final bool isDeleted;

  DivisionDto({
    required this.divisionId,
    required this.divisionName,
    required this.isDeleted,
  });

  factory DivisionDto.fromJson(Map<String, dynamic> json) {
    return DivisionDto(
      divisionId: json['divisionId'],
      divisionName: json['divisionName'],
      isDeleted: json['isDeleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'divisionId': divisionId,
      'divisionName': divisionName,
      'isDeleted': isDeleted,
    };
  }
}

class UserDto {
  final String userId;
  final String fullName;
  final String userName;
  final String email;
  final String phoneNumber;
  final String address;
  final String? avatar;
  final String gender;
  final String identityCard;
  final String createdAt;
  final String updatedAt;
  final String dateOfBirth;
  final String position;
  final String? fcmToken;
  final List<RoleDto> roles;
  final bool isDeleted;
  final bool isEnable;
  final String divisionId;
  final DivisionDto divisionDto;

  UserDto({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.avatar,
    required this.gender,
    required this.identityCard,
    required this.createdAt,
    required this.updatedAt,
    required this.dateOfBirth,
    required this.position,
    this.fcmToken,
    required this.roles,
    required this.isDeleted,
    required this.isEnable,
    required this.divisionId,
    required this.divisionDto,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      userId: json['userId'],
      fullName: json['fullName'],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      avatar: json['avatar'],
      gender: json['gender'],
      identityCard: json['identityCard'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      dateOfBirth: json['dateOfBirth'],
      position: json['position'],
      fcmToken: json['fcmToken'],
      roles: (json['roles'] as List)
          .map((roleJson) => RoleDto.fromJson(roleJson))
          .toList(),
      isDeleted: json['isDeleted'],
      isEnable: json['isEnable'],
      divisionId: json['divisionId'],
      divisionDto: DivisionDto.fromJson(json['divisionDto']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'avatar': avatar,
      'gender': gender,
      'identityCard': identityCard,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'dateOfBirth': dateOfBirth,
      'position': position,
      'fcmToken': fcmToken,
      'roles': roles.map((role) => role.toJson()).toList(),
      'isDeleted': isDeleted,
      'isEnable': isEnable,
      'divisionId': divisionId,
      'divisionDto': divisionDto.toJson(),
    };
  }
}
