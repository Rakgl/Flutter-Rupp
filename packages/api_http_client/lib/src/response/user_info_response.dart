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
  final String? name;
  final String? email;
  final String? image;
  final String? phone;
  final String? deliveryAddress;

  UserInfo({
    required this.id,
    this.name,
    this.email,
    this.image,
    this.phone,
    this.deliveryAddress,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      phone: json['phone'] as String?,
      deliveryAddress: json['delivery_address'] as String?,
    );
  }
}
