import 'package:api_http_client/api_http_client.dart';

class CategoryResponse extends BaseResponse {
  CategoryResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    categories = data.map((e) => Category.fromJson(e)).toList();
  }

  late List<Category> categories;
}

class Category {
  final String id;
  final String name;

  // factory
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  const Category({
    required this.id,
    required this.name,
  });
}
