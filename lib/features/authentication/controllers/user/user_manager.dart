import '../../models/login_response.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();

  factory UserManager() => _instance;

  UserManager._internal();

  UserDto? _user;
  String? _token;

  UserDto? get user => _user;
  String? get token => _token;

  String get id => _user?.userId ?? '';
  String get name => _user?.fullName ?? '';
  String get email => _user?.email ?? '';
  String get phone => _user?.phoneNumber ?? '';
  String get address => _user?.address ?? '';
  String get dateOfBirth => _user?.dateOfBirth ?? '';
  String get gender => _user?.gender ?? '';
  String? get avatar => _user?.avatar;
  String get divisionName => _user?.divisionDto.divisionName ?? '';
  String get position => _user?.position ?? '';


  void setUser(UserDto user, String token) {
    _user = user;
    _token = token;
  }

  void clear() {
    _user = null;
    _token = null;
  }

  bool get isLoggedIn => _user != null && _token != null;
}
