import 'package:intl/intl.dart';

class UserModel {
  final String? userId;
  final String? fullName;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? gender;
  final String? identityCard;
  final String? dateOfBirth;
  final String? position;
  final String? divisionName;
  final String avatar;
  final String? roleName;
  final String? sign;
  final String? signDigital;
  final int? numberOfDocuments;
  final int? numberOfArchiveDocuments;

  UserModel({
     this.userId,
     this.fullName,
     this.userName,
     this.email,
     this.phoneNumber,
     this.address,
     this.gender,
     this.identityCard,
     this.dateOfBirth,
     this.position,
     this.divisionName,
     required this.avatar,
     this.roleName,
     this.sign,
     this.signDigital,
     this.numberOfDocuments,
     this.numberOfArchiveDocuments,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final content = json['content'];
    final roles = content['roles'] as List<dynamic>;
    final roleName = roles.isNotEmpty ? roles[0]['roleName'] ?? 'Chưa cập nhật' : 'Chưa cập nhật';
    // Parse ngày sinh và format lại
    String formattedDate = 'Chưa cập nhật';
    if (content['dateOfBirth'] != null) {
      try {
        final parsedDate = DateTime.parse(content['dateOfBirth']);
        formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
      } catch (e) {
        formattedDate = 'Không hợp lệ';
      }
    }

    return UserModel(
      userId: content['userId'],
      fullName: content['fullName'],
      userName: content['userName'],
      email: content['email'],
      phoneNumber: content['phoneNumber'],
      address: content['address'] ?? 'Chưa cập nhật',
      gender: content['gender'],
      sign: content['sign'],
      signDigital: content['signDigital'],
      numberOfDocuments: content['signDnumberOfDocumentsigital'],
      numberOfArchiveDocuments: content['numberOfArchiveDocuments'],
      identityCard: content['identityCard'],
      dateOfBirth: formattedDate,
      // dateOfBirth: content['dateOfBirth'],
      position: content['position'] ?? 'Chưa cập nhật',
      divisionName: content['divisionDto']['divisionName'],
      avatar: content['avatar'] ?? '',
      roleName: roleName,
    );
  }
}

