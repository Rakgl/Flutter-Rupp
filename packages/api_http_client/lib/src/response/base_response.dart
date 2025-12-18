// json value cast extension
extension JsonValueCast on Map<String, dynamic> {
  String getStringOrDefault(String key, {String defaultValue = ''}) {
    if (this[key] is String) {
      return this[key] as String;
    } else {
      return defaultValue;
    }
  }

  int getIntOrDefault(String key, {int defaultValue = 0}) {
    if (this[key] is int) {
      return this[key] as int;
    } else {
      return defaultValue;
    }
  }

  double getDoubleOrDefault(String key, {double defaultValue = 0}) {
    if (this[key] is double) {
      return this[key] as double;
    } else {
      return defaultValue;
    }
  }

  bool getBoolOrDefault(String key, {bool defaultValue = false}) {
    if (this[key] is bool) {
      return this[key] as bool;
    } else {
      return defaultValue;
    }
  }

  List<Map<String, dynamic>> getListOrDefault(
    String key, {
    List<Map<String, dynamic>> defaultValue = const [],
  }) {
    if (this[key] is List) {
      final list = this[key] as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } else {
      return defaultValue;
    }
  }

  Map<String, dynamic> getMapOrDefault(
    String key, {
    Map<String, dynamic>? defaultValue,
  }) {
    if (this[key] is Map) {
      return this[key] as Map<String, dynamic>;
    } else {
      return defaultValue ?? {};
    }
  }

  // check map if map return string else null
  String? getStringOrNull(String key) {
    if (this[key] is Map) {
      final keyString = this[key] as Map<String, dynamic>;
      return keyString['en'] as String;
    } else {
      return null;
    }
  }

  Map<String, dynamic>? getMapOrNull(String key) {
    if (this[key] is Map) {
      return this[key] as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}

class BaseResponse {
  BaseResponse.fromJson(Map<String, dynamic> json) {
    success = json.getBoolOrDefault('success');
    message = json.getStringOrDefault('message');
  }

  late bool success;
  late String message;
}
