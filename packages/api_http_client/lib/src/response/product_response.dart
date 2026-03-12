import 'package:api_http_client/api_http_client.dart';

class ProductResponse extends BaseResponse {
  ProductResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getListOrDefault('data');
    products = List<Product>.from(data.map((x) => Product.fromJson(x)));
    
    final meta = json.getMapOrNull('meta');
    if (meta != null) {
      currentPage = meta.getIntOrDefault('current_page');
      lastPage = meta.getIntOrDefault('last_page');
      total = meta.getIntOrDefault('total');
    }
  }

  late List<Product> products;
  int currentPage = 1;
  int lastPage = 1;
  int total = 0;
  
  bool get isReachMax => currentPage >= lastPage;
}

class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final String? categoryName;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['image_url'] as String?,
      categoryName: json['category_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category_name': categoryName,
    };
  }
}
