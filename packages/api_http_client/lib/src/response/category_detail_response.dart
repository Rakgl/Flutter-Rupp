import 'package:equatable/equatable.dart';

import 'package:api_http_client/src/response/category_response.dart';

class CategoryDetailResponse extends Equatable {
  const CategoryDetailResponse({
    required this.category,
  });

  final Category category;

  factory CategoryDetailResponse.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return CategoryDetailResponse(
      category: Category.fromJson(data),
    );
  }

  @override
  List<Object?> get props => [category];
}
