import 'base_response.dart';

class SignInResponse extends BaseResponse {
  SignInResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getMapOrDefault('data');
    accessToken = data.getStringOrDefault('accessToken');
    refreshToken = data.getStringOrDefault('refreshToken');
    appContext = data.getStringOrDefault('appContext');
    expiresIn = data.getIntOrDefault('expiresIn', defaultValue: 600);

    final userData = data.getMapOrNull('user');
    if (userData != null) {
      user = UserData.fromJson(userData);
    }
  }
  late String accessToken;
  late String refreshToken;
  late String appContext;
  late int expiresIn;
  UserData? user;
}

class UserData {
  final String id;
  final String username;
  final ProfessionalData? professional;

  UserData({
    required this.id,
    required this.username,
    this.professional,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json.getStringOrDefault('id'),
      username: json.getStringOrDefault('username'),
      professional: json['professional'] != null
          ? ProfessionalData.fromJson(
              json['professional'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ProfessionalData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String image;

  ProfessionalData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.image,
  });

  factory ProfessionalData.fromJson(Map<String, dynamic> json) {
    return ProfessionalData(
      id: json.getStringOrDefault('id'),
      name: json.getStringOrDefault('name'),
      email: json.getStringOrDefault('email'),
      phone: json.getStringOrDefault('phone'),
      address: json.getStringOrDefault('address'),
      image: json.getStringOrDefault('image'),
    );
  }
}
