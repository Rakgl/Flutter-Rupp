import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';
import 'package:api_http_client/api_http_client.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({required ProductRepository productRepository})
    : _productRepository = productRepository,
      super(const ProductsState());

  final ProductRepository _productRepository;

  Future<void> fetchProducts() async {
    emit(state.copyWith(status: ProductStatus.loading));
    final response = await _productRepository.getProducts(page: 1);
    await response.when<void>(
      success: (ProductResponse productResponse) async {
        emit(
          state.copyWith(
            status: ProductStatus.success,
            products: productResponse.products,
            isReachMax: productResponse.isReachMax,
          ),
        );
      },
      failure: (String error) async {
        emit(
          state.copyWith(
            status: ProductStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }
}
