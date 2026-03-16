import 'package:api_http_client/api_http_client.dart';

class CartResponse extends BaseResponse {
  CartResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final data = json.getMapOrNull('data');
    if (data != null) {
      carts = CartModel.fromJson(data);
    }
  }
  late CartModel carts;
}

class CartModel {
  final String id;
  final String status;
  final double grandTotal;
  final String currency;
  final List<CartItemModel> items;
  
  CartModel({
    required this.id,
    required this.status,
    required this.grandTotal,
    required this.currency,
    required this.items,
  });
  
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json.getStringOrDefault('id'),
      status: json.getStringOrDefault('status'),
      grandTotal: json.getDoubleOrDefault('grand_total') != 0.0 
          ? json.getDoubleOrDefault('grand_total') 
          : json.getDoubleOrDefault('subtotal'),
      currency: json.getStringOrDefault('currency', defaultValue: '\$'),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

class CartItemModel {
  final String id;
  final String cartId;
  final String type; // product or pet_listing
  final int quantity;
  final String name; // Now formatted as "PetName (Breed)" by backend for pets
  final String imageUrl;
  final double price;
  final String? categoryName;

  CartItemModel({
    required this.id,
    required this.cartId,
    required this.type,
    required this.quantity,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.categoryName,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final itemData = json.getMapOrDefault('item');
    return CartItemModel(
      id: json.getStringOrDefault('id'),
      cartId: json.getStringOrDefault('cart_id'),
      type: json.getStringOrDefault('type'), // product or pet_listing
      quantity: json.getIntOrDefault('quantity'),
      name: itemData['name']?.toString() ?? 'Unknown',
      imageUrl: itemData['image_url']?.toString() ?? '',
      price: double.tryParse(itemData['price']?.toString() ?? '0') ?? 0.0,
      categoryName: itemData['category_name']?.toString(),
    );
  }
}
