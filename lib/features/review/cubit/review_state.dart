part of 'review_cubit.dart';

enum ReviewStatus { initial, loading, success, failure }

class ReviewState {
  const ReviewState({
    this.status = ReviewStatus.initial,
  });

  final ReviewStatus status;
}
