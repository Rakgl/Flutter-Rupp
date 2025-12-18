import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http_client/http_client.dart';
import 'package:token_storage/token_storage.dart';

class AuthenticationQueuedInterceptor extends QueuedInterceptor {
  AuthenticationQueuedInterceptor({
    required TokenStorage tokenStorage,
    required String baseUrl,
  })  : _tokenStorage = tokenStorage,
        _baseUrl = baseUrl;

  final String _baseUrl;
  final TokenStorage _tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.readToken();
    final accessToken = token[0];
    final refreshToken = token[1];

    if (accessToken != null && refreshToken != null) {
      final accessTokenDuration = await _tokenStorage.getAccessTokenDuration();

      log("The access token expiration: ${accessTokenDuration.inSeconds}");

      // if less than 60 seconds left, refresh token
      if (accessTokenDuration.inSeconds < 60) {
        await onRefreshToken(refreshToken, accessToken, options, handler);
      } else {
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      }
    } else {
      return handler.next(options);
    }
  }

  // on refresh token
  Future<void> onRefreshToken(
    String refreshToken,
    String accessToken,
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // implement refresh token
    try {
      final request = {
        'refresh_token': refreshToken,
      };
      final dio = Dio();
      final response = await dio.post<Map<String, dynamic>>(
        '$_baseUrl/auth/refresh-token',
        data: request,
        options: Options(
          contentType: 'application/json',
        ),
      );

      final res = AppTokenResponse.fromJson(
        response.data!,
      );

      if (response.statusCode == 200) {
        // save new token
        if (response.data!['success'] as bool) {
          final access = res.accessToken;
          final refresh = res.refreshToken;

          if (access.isEmpty || refresh.isEmpty) {
            throw DioException(requestOptions: options);
          }
          await _tokenStorage.writeToken(
            accessToken: access,
            refreshToken: refresh,
            expireIn: res.expiresIn.toString(),
          );
          options.headers['Authorization'] = 'Bearer $access';
          return handler.next(options);
        } else {
          await _tokenStorage.clearAccessToken();
          throw DioException(requestOptions: options);
        }
      } else {
        await _tokenStorage.clearAccessToken();
        throw DioException(requestOptions: options);
      }
    } on DioException catch (e) {
      await _tokenStorage.clearAccessToken();
      return handler.reject(e);
    }
  }
}

// logger interceptor
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    log('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log('RESPONSE[${response.statusCode}] => PATH:'
        ' ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    log('ERROR[${err.response?.statusCode}] => '
        'PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}
