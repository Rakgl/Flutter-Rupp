import 'dart:convert';

class ServiceResponse {
  ServiceResponse({
    required this.services,
    this.isReachMax = false,
  });

  late List<ServiceModel> services;
  late bool isReachMax;

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<dynamic> dataList = [];
    if (rawData is List) {
      dataList = rawData;
    } else if (rawData is Map && rawData['data'] is List) {
      dataList = rawData['data'] as List<dynamic>;
    }
    return ServiceResponse(
      services: dataList
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isReachMax: json['next_page_url'] == null,
    );
  }
}

class ServiceModel {
  final String id;
  final Map<String, dynamic> nameObj;
  final Map<String, dynamic> descriptionObj;
  final String price;
  final int durationMinutes;
  final String? imageUrl;
  final String status;
  final bool isFavorite;

  ServiceModel({
    required this.id,
    required this.nameObj,
    required this.descriptionObj,
    required this.price,
    this.durationMinutes = 0,
    this.imageUrl,
    this.status = 'ACTIVE',
    this.isFavorite = false,
  });

  String get name =>
      nameObj['en']?.toString() ?? nameObj['kh']?.toString() ?? '';
  String get description =>
      descriptionObj['en']?.toString() ?? descriptionObj['kh']?.toString() ?? '';

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? '',
      nameObj: _parseLocalized(json['name']),
      descriptionObj: _parseLocalized(json['description']),
      price: json['price']?.toString() ?? '0.00',
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      imageUrl: json['image_url']?.toString(),
      status: json['status']?.toString() ?? 'ACTIVE',
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  /// Handles both: a proper Map {"en": "..."} and a JSON-encoded string "{\"en\": \"...\"}"
  static Map<String, dynamic> _parseLocalized(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {}
      return {'en': value};
    }
    return {};
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': nameObj,
        'description': descriptionObj,
        'price': price,
        'duration_minutes': durationMinutes,
        'image_url': imageUrl,
        'status': status,
        'is_favorite': isFavorite,
      };
}
