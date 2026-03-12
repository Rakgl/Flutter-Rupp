import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:api_http_client/api_http_client.dart';
import 'package:repository/repository.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(const CategoriesState());

  final CategoryRepository _categoryRepository;

  Future<void> fetchCategories() async {
    emit(state.copyWith(status: CategoriesStatus.loading));
    final response = await _categoryRepository.getCategories();
    await response.when<void>(
      success: (CategoryResponse categoryResponse) async {
        emit(
          state.copyWith(
            status: CategoriesStatus.success,
            categories: categoryResponse.categories,
          ),
        );
      },
      failure: (String error) async {
        emit(
          state.copyWith(
            status: CategoriesStatus.failure,
            errorMessage: error,
          ),
        );
      },
    );
  }
}
