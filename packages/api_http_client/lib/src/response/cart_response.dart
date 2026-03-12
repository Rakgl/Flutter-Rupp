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
      grandTotal: json.getDoubleOrDefault('subtotal'), // Default to subtotal since grand_total is missing
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
  final String? itemType;
  final int quantity;
  final Map<String, dynamic> item;

  CartItemModel({
    required this.id,
    required this.cartId,
    this.itemType,
    required this.quantity,
    required this.item,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json.getStringOrDefault('id'),
      cartId: json.getStringOrDefault('cart_id'),
      itemType: json.getStringOrDefault('item_type'),
      quantity: json.getIntOrDefault('quantity'),
      item: json.getMapOrDefault('item'),
    );
  }

  // Helpers for UI display
  String get name {
    final n = item['name'];
    if (n == null) return 'Unknown';
    if (n is Map) {
      return n['en']?.toString() ?? n.values.firstOrNull?.toString() ?? 'Unknown';
    }
    return n.toString();
  }
  String get imageUrl => item['image_url']?.toString() ?? '';
  double get price {
    final p = item['price'];
    if (p == null) return 0.0;
    return double.tryParse(p.toString()) ?? 0.0;
  }
}

class PharmacyProductModel {
  final String id;
  final String pharmacyId;
  final String productVariantId;
  final String  price;
  final String? salePrice;
  final int quantity;
  final bool isPopular;
  final bool isOnSale;
  final String stockStatus;
  final ProductVariant productVariant;

  PharmacyProductModel({
    required this.id,
    required this.pharmacyId,
    required this.productVariantId,
    required this.price,
    this.salePrice,
    required this.quantity,
    required this.isPopular,
    required this.isOnSale,
    required this.stockStatus,
    required this.productVariant,
  });

  factory PharmacyProductModel.fromJson(Map<String, dynamic> json) {
    return PharmacyProductModel(
      id: json.getStringOrDefault('id'),
      pharmacyId: json.getStringOrDefault('pharmacy_id'),
      productVariantId: json.getStringOrDefault('product_variant_id'),
      price: json.getStringOrDefault('price'),
      salePrice: json.getStringOrDefault('sale_price'),
      quantity: json.getIntOrDefault('quantity'),
      isPopular: json.getBoolOrDefault('is_popular'),
      isOnSale: json.getBoolOrDefault('is_on_sale'),
      stockStatus: json.getStringOrDefault('stock_status'),
      productVariant: ProductVariant.fromJson(
        json.getMapOrDefault('product_variant'),
      ),
    );
  }
}

class ProductVariant {

  final String id;
  final String productId;
  final String name;  
  final String? size;
  final String unitId;
  final String sku;
  final String? imageUrl;
  final bool isDefault;
  final String status;
  final ProductItem product;



  const ProductVariant({
    required this.id,
    required this.productId,
    required this.name,
    this.size,
    required this.unitId,
    required this.sku,
    this.imageUrl,
    required this.isDefault,
    required this.status,
    required this.product,

  });


  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json.getStringOrDefault('id'),
      productId: json.getStringOrDefault('product_id'),
      name: json.getStringOrDefault('name'),
      size: json.getStringOrDefault('size'),
      unitId: json.getStringOrDefault('unit_id'),
      sku: json.getStringOrDefault('sku'),
      imageUrl: json.getStringOrDefault('image_url'),
      isDefault: json.getBoolOrDefault('is_default'),
      status: json.getStringOrDefault('status'),
      product: ProductItem.fromJson(json.getMapOrDefault('product')),

    );
  }

}

class PharmacyModel {
  final String id;
  final String name;
  final String? logoUrl;

  const PharmacyModel({
    required this.id,
    required this.name,
    this.logoUrl,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json.getStringOrDefault('id'),
      name: json.getStringOrDefault('name'),
      logoUrl: json.getStringOrDefault('logo_url'),
    );
  }
}

class ProductItem {
  final String id;
  final String categoryId;
  final String name;
  final String type;
  final String? imageUrl;
  final String description;
  final String brandId;
  final bool requiresPrescription;
  final String status;

  const ProductItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.type,
    this.imageUrl,
    required this.description,
    required this.brandId,
    required this.requiresPrescription,
    required this.status,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json.getStringOrDefault('id'),
      categoryId: json.getStringOrDefault('category_id'),
      name: json.getStringOrDefault('name'),
      type: json.getStringOrDefault('type'),
      imageUrl: json.getStringOrDefault('image_url'),
      description: json.getStringOrDefault('description'),
      brandId: json.getStringOrDefault('brand_id'),
      requiresPrescription: json.getBoolOrDefault('requires_prescription'),
      status: json.getStringOrDefault('status'),
    );
  }
}
