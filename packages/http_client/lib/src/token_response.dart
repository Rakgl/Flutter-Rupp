import 'package:api_http_client/api_http_client.dart';

class AppTokenResponse {
  AppTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.success,
    required this.expiresIn,
  });

  factory AppTokenResponse.fromJson(Map<String, dynamic> json) {
    final data = json.getMapOrDefault('data');
    return AppTokenResponse(
      accessToken: data.getStringOrDefault('access_token'),
      refreshToken: data.getStringOrDefault('refresh_token'),
      success: data.getBoolOrDefault('success'),
      expiresIn: data.getIntOrDefault('expires_in'),
    );
  }

  final String accessToken;
  final String refreshToken;
  final bool success;
  final int expiresIn;
}
