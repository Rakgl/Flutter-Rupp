import 'package:equatable/equatable.dart';

class ProductDetailResponse extends Equatable {
  const ProductDetailResponse({
    this.data,
  });

  final dynamic data;

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      data: json['data'],
    );
  }

  @override
  List<Object?> get props => [data];
}
