import 'package:flutter/material.dart';


class UserDto {
  final String userId;
  final String fullName;
  final String userName;
  final String email;
  final String phoneNumber;
  final String? avatar;

  UserDto({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    this.avatar,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      userId: json['userId'],
      fullName: json['fullName'],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      avatar: json['avatar'],
    );
  }
}


class LoginResponse {
  final UserDto user;
  final String token;
  final String refreshToken;

  LoginResponse({
    required this.user,
    required this.token,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final content = json['content'];
    return LoginResponse(
      user: UserDto.fromJson(content['userDto']),
      token: content['token'],
      refreshToken: content['refreshToken'],
    );
  }
}
