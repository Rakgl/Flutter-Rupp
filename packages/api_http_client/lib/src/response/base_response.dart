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
    final value = this[key];
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  double getDoubleOrDefault(String key, {double defaultValue = 0}) {
    final value = this[key];
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
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
    success = json.getBoolOrDefault('success', defaultValue: true);
    message = json.getStringOrNull('message');
  }

  late bool success;
  String? message;
}
