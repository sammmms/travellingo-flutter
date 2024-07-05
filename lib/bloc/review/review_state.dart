import 'package:travellingo/models/review.dart';
import 'package:travellingo/utils/app_error.dart';

class ReviewState {
  final List<Review>? reviews;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  ReviewState({
    this.reviews,
    this.isLoading = false,
    this.hasError = false,
    this.error,
  });

  factory ReviewState.initial() => ReviewState();

  factory ReviewState.loading() => ReviewState(isLoading: true);

  factory ReviewState.error(AppError? error) =>
      ReviewState(hasError: true, error: error);

  factory ReviewState.success(List<Review>? reviews) =>
      ReviewState(reviews: reviews);

  ReviewState copyWith({
    List<Review>? reviews,
    bool? isLoading,
    bool? hasError,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}
