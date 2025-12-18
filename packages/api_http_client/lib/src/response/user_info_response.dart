import 'package:api_http_client/api_http_client.dart';

class UserInfoResponse extends BaseResponse {
  UserInfoResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getMapOrDefault('data');
    user = UserInfo.fromJson(data);
  }

  late UserInfo user;
}

class UserInfo {
  final String id;
  final String name;
  final String email;
  final String? image;
  final String? phone;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    this.phone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      phone: json['phone'],
    );
  }
}
