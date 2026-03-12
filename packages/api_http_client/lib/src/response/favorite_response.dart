import 'package:api_http_client/api_http_client.dart';

class FavoriteResponse extends BaseResponse {
  FavoriteResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final list = json.getListOrDefault('data');
    favorites = list.map((e) => FavoriteItemModel.fromJson(e)).toList();
  }

  late List<FavoriteItemModel> favorites;
}

class FavoriteItemModel {
  final String id;
  final String? itemableType;
  final String? itemableId;
  final Map<String, dynamic> item;

  FavoriteItemModel({
    required this.id,
    this.itemableType,
    this.itemableId,
    required this.item,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
      id: json['id']?.toString() ?? '',
      itemableType: json['itemable_type'] as String?,
      itemableId: json['itemable_id']?.toString(),
      item: json.getMapOrDefault('item'),
    );
  }

  String get name {
    final rawName = item['name'] ?? item['title'] ?? '';
    if (rawName is Map) {
      return (rawName['en'] ?? rawName.values.firstOrNull ?? '').toString();
    }
    return rawName.toString();
  }

  double get price {
    return double.tryParse(item['price']?.toString() ?? '0') ?? 0.0;
  }

  String get imageUrl {
    return item['image_url']?.toString() ?? item['image']?.toString() ?? '';
  }

  String get type {
    return itemableType?.split('\\').last.toLowerCase() ?? item['type']?.toString() ?? 'product';
  }
}
