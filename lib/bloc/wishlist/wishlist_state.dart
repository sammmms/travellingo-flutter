import 'package:travellingo/models/place.dart';
import 'package:travellingo/utils/app_error.dart';

class WishlistState {
  final List<Place>? places;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  WishlistState(
      {this.places, this.isLoading = false, this.hasError = false, this.error});

  factory WishlistState.initial() => WishlistState();

  factory WishlistState.loading() => WishlistState(isLoading: true);

  factory WishlistState.error(AppError? error) =>
      WishlistState(hasError: true, error: error);

  factory WishlistState.success(List<Place> places) =>
      WishlistState(places: places);

  WishlistState copyWith({
    List<Place>? places,
    bool? isLoading,
    bool? hasError,
  }) {
    return WishlistState(
      places: places ?? this.places,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}
