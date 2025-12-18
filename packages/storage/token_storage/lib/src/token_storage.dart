import 'dart:async';

import 'package:storage/storage.dart';

class TokenStorage {
  TokenStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  static const String __accessToken__ = '__accessToken__';
  static const String __refreshToken__ = '__refreshToken__';
  static const String __expireIn__ = '__expireIn__';

  // streaming token
  final _accessTokenStream = StreamController<String?>.broadcast();
  final _refreshTokenStream = StreamController<String?>.broadcast();
  final _expireInStream = StreamController<String?>.broadcast();

  Stream<String?> get accessTokenStream => _accessTokenStream.stream;
  Stream<String?> get refreshTokenStream => _refreshTokenStream.stream;

  Future<void> writeToken({
    required String accessToken,
    required String refreshToken,
    required String expireIn,
  }) async {
    final issuedAt = DateTime.now().millisecondsSinceEpoch.toString();
    await Future.wait([
      _storage.write(key: __accessToken__, value: accessToken),
      _storage.write(key: __refreshToken__, value: refreshToken),
      _storage.write(key: __expireIn__, value: expireIn),
      _storage.write(key: '__issuedAt__', value: issuedAt),
    ]);
    _accessTokenStream.add(accessToken);
    _refreshTokenStream.add(refreshToken);
    _expireInStream.add(expireIn);
  }

  // get token
  Future<List<String?>> readToken() async {
    final token = await Future.wait([
      _storage.read(key: __accessToken__),
      _storage.read(key: __refreshToken__),
      _storage.read(key: __expireIn__),
    ]);
    _accessTokenStream.add(token[0]);
    _refreshTokenStream.add(token[1]);
    _expireInStream.add(token[2]);
    return token;
  }

  // clear token
  Future<void> clearToken() async {
    await Future.wait([
      _storage.delete(key: __accessToken__),
      _storage.delete(key: __refreshToken__),
      _storage.delete(key: __expireIn__),
      _storage.delete(key: '__issuedAt__'),
    ]);
    _accessTokenStream.add(null);
    _refreshTokenStream.add(null);
    _expireInStream.add(null);
  }

  // clear access token
  Future<void> clearAccessToken() async {
    await _storage.delete(key: __accessToken__);
    _accessTokenStream.add(null);
  }

  Future<Duration> getAccessTokenDuration() async {
    final expireInString = await _storage.read(key: __expireIn__);
    final issuedAtString = await _storage.read(key: '__issuedAt__');

    if (expireInString == null || issuedAtString == null) {
      return Duration.zero;
    }

    try {
      final expireInSeconds = int.parse(expireInString);
      final issuedAtMillis = int.parse(issuedAtString);
      final nowMillis = DateTime.now().millisecondsSinceEpoch;

      final expireAtMillis = issuedAtMillis + (expireInSeconds * 1000);
      final remainingMillis = expireAtMillis - nowMillis;

      return Duration(
          milliseconds: remainingMillis.clamp(0, expireInSeconds * 1000));
    } catch (e) {
      return Duration.zero;
    }
  }

  // get access token as String
  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: __accessToken__);
    return token;
  }
}
