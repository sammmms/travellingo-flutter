import 'package:travellingo/models/place.dart';
import 'package:travellingo/utils/app_error.dart';

class PlaceState {
  final List<Place>? data;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  PlaceState({
    this.data,
    this.isLoading = false,
    this.hasError = false,
    this.error,
  });

  PlaceState copyWith({
    List<Place>? places,
    bool? isLoading,
    bool? hasError,
    AppError? error,
  }) {
    return PlaceState(
      data: places ?? data,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
    );
  }

  factory PlaceState.initial() {
    return PlaceState();
  }

  factory PlaceState.hasError({required AppError error}) {
    return PlaceState(hasError: true, error: error);
  }

  factory PlaceState.isLoading() {
    return PlaceState(isLoading: true);
  }
}
