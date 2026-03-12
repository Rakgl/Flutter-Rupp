import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';
import 'package:api_http_client/api_http_client.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(const ProductDetailState());

  final ProductRepository _productRepository;

  Future<void> fetchProduct(String id) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    final response = await _productRepository.getProduct(id: id);
    await response.when<void>(
      success: (ProductDetailResponse productDetailResponse) async {
        final product = Product.fromJson(productDetailResponse.data as Map<String, dynamic>);
        emit(
          state.copyWith(
            status: ProductDetailStatus.success,
            product: product,
          ),
        );
      },
      failure: (String error) async {
        emit(
          state.copyWith(
            status: ProductDetailStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }
}
