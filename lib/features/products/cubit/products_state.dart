part of 'products_cubit.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductStatus.initial,
    this.products = const <Product>[],
    this.isReachMax = false,
    this.errorMessage,
  });

  final ProductStatus status;
  final List<Product> products;
  final bool isReachMax;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, products, isReachMax, errorMessage];

  ProductsState copyWith({
    ProductStatus? status,
    List<Product>? products,
    bool? isReachMax,
    String? errorMessage,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      isReachMax: isReachMax ?? this.isReachMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
