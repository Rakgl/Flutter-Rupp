import 'package:api_http_client/api_http_client.dart';

class ToggleFavoriteResponse extends BaseResponse {
  final bool isFavorite;

  ToggleFavoriteResponse.fromJson(Map<String, dynamic> json)
      : isFavorite = json['is_favorite'] as bool? ?? false,
        super.fromJson(json);
}
