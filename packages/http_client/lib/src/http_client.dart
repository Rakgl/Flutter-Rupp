import 'package:dio/dio.dart' hide ProgressCallback;
import 'package:http_client/src/interceptor.dart';
import 'package:token_storage/token_storage.dart';

/// ProgressCallbackX is a typedef for a function that takes two integers and
/// returns nothing. This is used by the [ProgressCallback] method.
typedef ProgressCallback = void Function(int count, int total);

/// Base class for all http clients.
abstract class HttpClient {
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  /// [post] sends a HTTP POST request
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Object? body,
  });

  /// [put] sends a HTTP PUT request
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  });

  /// [delete] sends a HTTP DELETE request
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  /// [downloadFile] downloads a file from the given [path] and saves it to the
  /// given [savePath]. It returns a [Future] that completes when the download
  /// is finished. The [onReceiveProgress] callback is called whenever a chunk
  /// of data is received. The [queryParameters] and [headers] are optional.
  /// The [queryParameters] are added to the url as query parameters and the
  /// [headers] are added to the request headers.
  Future<void> downloadFile(
    String path, {
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required ProgressCallback onReceiveProgress,
  });
}

/// {@template baby_outlet_api_malformed_response}
/// An exception that is thrown when the response from the BabyOutlet API is
/// {@endtemplate}
class ApiMalformedResponse implements Exception {
  /// {@macro baby_outlet_api_malformed_response}
  ApiMalformedResponse({
    required this.error,
  });

  /// The error that occurred.
  final FormatException error;

  @override
  String toString() => 'ApiMalformedResponse(error: $error)';
}

/// {@template baby_outlet_api_request_failure}
/// An exception that is thrown when an http request fails.
/// {@endtemplate}
class ApiRequestFailure implements Exception {
  /// {@macro baby_outlet_api_request_failure}
  const ApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// The associated http status code.
  final int statusCode;

  /// The associated response body.
  final Map<String, dynamic> body;
}

/// {@template dio_http_client}
/// A client for making http requests using the Dio package.
/// {@endtemplate}
class DioHttpClient implements HttpClient {
  /// {@macro dio_http_client}
  DioHttpClient({
    required Dio dio,
    required String baseUrl,
    required TokenStorage tokenStorage,
  })  : _dio = dio,
        _baseUrl = baseUrl,
        _tokenStorage = tokenStorage {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(LoggingInterceptor());
    _dio.options.connectTimeout = const Duration(seconds: 120);
    _dio.options.receiveTimeout = const Duration(seconds: 120);
    _dio.interceptors.add(
      AuthenticationQueuedInterceptor(
        baseUrl: _baseUrl,
        tokenStorage: _tokenStorage,
      ),
    );
  }

  final Dio _dio;
  final String _baseUrl;
  final TokenStorage _tokenStorage;

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data!;
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiRequestFailure(
          statusCode: e.response!.statusCode!,
          body: e.response!.data as Map<String, dynamic>,
        );
      } else {
        rethrow;
      }
    } on FormatException catch (e) {
      throw ApiMalformedResponse(error: e);
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Object? body,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        data: body,
      );
      return response.data!;
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiRequestFailure(
          statusCode: e.response!.statusCode!,
          body: e.response!.data as Map<String, dynamic>,
        );
      } else {
        rethrow;
      }
    } on FormatException catch (e) {
      throw ApiMalformedResponse(error: e);
    }
  }

  @override
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        data: body,
      );
      return response.data!;
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiRequestFailure(
          statusCode: e.response!.statusCode!,
          body: e.response!.data as Map<String, dynamic>,
        );
      } else {
        rethrow;
      }
    } on FormatException catch (e) {
      throw ApiMalformedResponse(error: e);
    }
  }

  @override
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data!;
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiRequestFailure(
          statusCode: e.response!.statusCode!,
          body: e.response!.data as Map<String, dynamic>,
        );
      } else {
        rethrow;
      }
    } on FormatException catch (e) {
      throw ApiMalformedResponse(error: e);
    }
  }

  @override
  Future<void> downloadFile(
    String path, {
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required ProgressCallback onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiRequestFailure(
          statusCode: e.response!.statusCode!,
          body: e.response!.data as Map<String, dynamic>,
        );
      } else {
        rethrow;
      }
    }
  }
}
