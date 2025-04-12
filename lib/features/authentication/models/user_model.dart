class UserModel {
  final String userId;
  final String fullName;
  final String userName;
  final String email;
  final String phoneNumber;
  final String address;
  final String gender;
  final String identityCard;
  final String dateOfBirth;
  final String position;
  final String divisionName;
  final String avatar;
  final String roleName;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    required this.identityCard,
    required this.dateOfBirth,
    required this.position,
    required this.divisionName,
    required this.avatar,
    required this.roleName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final content = json['content'];
    final roles = content['roles'] as List<dynamic>;
    final roleName = roles.isNotEmpty ? roles[0]['roleName'] ?? 'Chưa cập nhật' : 'Chưa cập nhật';

    return UserModel(
      userId: content['userId'],
      fullName: content['fullName'],
      userName: content['userName'],
      email: content['email'],
      phoneNumber: content['phoneNumber'],
      address: content['address'] ?? 'Chưa cập nhật',
      gender: content['gender'],
      identityCard: content['identityCard'],
      dateOfBirth: content['dateOfBirth'],
      position: content['position'] ?? 'Chưa cập nhật',
      divisionName: content['divisionDto']['divisionName'],
      avatar: content['avatar'] ?? '',
      roleName: roleName,
    );
  }
}

