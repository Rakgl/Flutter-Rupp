import 'base_response.dart';

class SignInResponse extends BaseResponse {
  SignInResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getMapOrDefault('data');
    accessToken = data.getStringOrDefault('access_token');
    refreshToken = data.getStringOrDefault('refresh_token');
    tokenType = data.getStringOrDefault('token_type');
    expiresIn = data.getIntOrDefault('expires_in');
  }
  late String accessToken;
  late String refreshToken;
  late String tokenType;
  late int expiresIn;
}
