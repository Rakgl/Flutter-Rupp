import 'package:api_http_client/api_http_client.dart';

class CategoryResponse extends BaseResponse {
  CategoryResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final dataList = json.getListOrDefault('data');
    categories = dataList.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();

    // Handle nested meta for pagination
    if (json.containsKey('meta')) {
      final meta = json['meta'] as Map<String, dynamic>;
      currentPage = meta.getIntOrDefault('current_page', defaultValue: 1);
      lastPage = meta.getIntOrDefault('last_page', defaultValue: 1);
      total = meta.getIntOrDefault('total', defaultValue: 0);
    } else {
      currentPage = json.getIntOrDefault('current_page', defaultValue: 1);
      lastPage = json.getIntOrDefault('last_page', defaultValue: 1);
      total = json.getIntOrDefault('total', defaultValue: 0);
    }
  }

  late List<Category> categories = [];
  int currentPage = 1;
  int lastPage = 1;
  int total = 0;

  bool get isReachMax => currentPage >= lastPage;
}

class Category {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? type;
  final String? slug;
  final String? status;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.type,
    this.slug,
    this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      type: json['type']?.toString(),
      slug: json['slug']?.toString(),
      status: json['status']?.toString(),
    );
  }
}
