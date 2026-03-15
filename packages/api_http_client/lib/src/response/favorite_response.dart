import 'dart:developer';

import 'package:api_http_client/api_http_client.dart';

class FavoriteResponse extends BaseResponse {
  FavoriteResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final list = json.getListOrDefault('data');
    log('[FavoriteResponse] Parsing ${list.length} items from JSON');
    favorites = list.map((e) => FavoriteItemModel.fromJson(e)).toList();
  }

  late List<FavoriteItemModel> favorites;
}

class FavoriteItemModel {
  final String id;
  final String type;
  final String? itemId;
  final Map<String, dynamic> details;

  FavoriteItemModel({
    required this.id,
    required this.type,
    required this.itemId,
    required this.details,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    // Take itemId from either the root 'item_id' or from the 'details' map
    final rootItemId = json['item_id']?.toString();
    final detailsMap = json.getMapOrDefault('details');
    final detailsId = detailsMap['id']?.toString();
    
    // Sometimes the type is in the root, sometimes in details
    final rootType = json['type']?.toString();
    final itemType = json['item_type']?.toString();
    final detailsType = detailsMap['type']?.toString();

    final model = FavoriteItemModel(
      id: json['id']?.toString() ?? '',
      type: rootType ?? (itemType ?? (detailsType ?? 'product')),
      itemId: rootItemId ?? detailsId,
      details: detailsMap,
    );
    log('[FavoriteItemModel] Created: id=${model.id}, type=${model.type}, itemId=${model.itemId}');
    return model;
  }

  String get name {
    final rawName = details['name'] ?? details['title'] ?? '';
    if (rawName is Map) {
      return (rawName['en'] ?? rawName.values.firstOrNull ?? '').toString();
    }
    return rawName.toString();
  }

  double get price {
    return double.tryParse(details['price']?.toString() ?? '0') ?? 0.0;
  }

  String get imageUrl {
    return details['image_url']?.toString() ?? details['image']?.toString() ?? '';
  }
}
