import 'package:api_http_client/api_http_client.dart';
import 'package:equatable/equatable.dart';

enum CategoryDetailStatus { initial, loading, success, failure }

class CategoryDetailState extends Equatable {
  const CategoryDetailState({
    this.status = CategoryDetailStatus.initial,
    this.category,
    this.errorMessage,
  });

  final CategoryDetailStatus status;
  final Category? category;
  final String? errorMessage;

  CategoryDetailState copyWith({
    CategoryDetailStatus? status,
    Category? category,
    String? errorMessage,
  }) {
    return CategoryDetailState(
      status: status ?? this.status,
      category: category ?? this.category,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, category, errorMessage];
}
