class SignInRequest {
  SignInRequest({
    required this.username,
    required this.password,
    required this.appContext,
    required this.deviceId,
  });
  final String username;
  final String password;
  final String appContext;
  final String deviceId;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'appContext': appContext,
      'deviceId': deviceId,
    };
  }
}
