import 'package:bloc/bloc.dart';
import 'package:api_http_client/api_http_client.dart';
import 'package:flutter_methgo_app/features/categories/cubit/category_detail_state.dart';
import 'package:repository/repository.dart';

class CategoryDetailCubit extends Cubit<CategoryDetailState> {
  CategoryDetailCubit({
    required CategoryRepository categoryRepository,
  })  : _categoryRepository = categoryRepository,
        super(const CategoryDetailState());

  final CategoryRepository _categoryRepository;

  Future<void> fetchCategory({required String id}) async {
    emit(state.copyWith(status: CategoryDetailStatus.loading));
    final result = await _categoryRepository.getCategory(id: id);
    await result.when<void>(
      success: (CategoryDetailResponse response) async {
        emit(state.copyWith(
          status: CategoryDetailStatus.success,
          category: response.category,
        ));
      },
      failure: (String error) async {
        emit(state.copyWith(
          status: CategoryDetailStatus.failure,
          errorMessage: error,
        ));
      },
    );
  }
}
