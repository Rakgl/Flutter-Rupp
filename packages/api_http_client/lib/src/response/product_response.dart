import 'package:api_http_client/api_http_client.dart';

class ProductResponse extends BaseResponse {
  ProductResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getListOrDefault('data');

    products = List<Product>.from(data.map((x) => Product.fromJson(x)));
    isReachMax = json['reach_max'];
  }

  late List<Product> products;

  late bool isReachMax;
}

class Product {
  final String id;
  final double price;
  final double? salePrice;
  final int quantity;
  final bool isPopular;
  final bool isOnSale;
  final String stockStatus;
  final SubProduct product;
  final Variant variant;

  Product({
    required this.id,
    required this.price,
    this.salePrice,
    required this.quantity,
    required this.isPopular,
    required this.isOnSale,
    required this.stockStatus,
    required this.product,
    required this.variant,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      price: double.parse(json['price'].toString()),
      salePrice: json['sale_price'] != null
          ? double.tryParse(json['sale_price'].toString())
          : null,
      quantity: json['quantity'],
      isPopular: json['is_popular'],
      isOnSale: json['is_on_sale'],
      stockStatus: json['stock_status'],
      product: SubProduct.fromJson(json['product']),
      variant: Variant.fromJson(json['variant']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price.toString(),
      'sale_price': salePrice?.toString(),
      'quantity': quantity,
      'is_popular': isPopular,
      'is_on_sale': isOnSale,
      'stock_status': stockStatus,
      'product': product.toJson(),
      'variant': variant.toJson(),
    };
  }
}

class SubProduct {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String category;

  SubProduct({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.category,
  });

  factory SubProduct.fromJson(Map<String, dynamic> json) {
    return SubProduct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'category': category,
    };
  }
}

class Variant {
  final String id;
  final String name;
  final String? size;
  final String unit;

  Variant({
    required this.id,
    required this.name,
    this.size,
    required this.unit,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      name: json['name'],
      size: json['size'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'unit': unit,
    };
  }
}
