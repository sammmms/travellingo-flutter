import 'package:travellingo/models/place.dart';

class PlaceState {
  final List<Place>? data;
  final bool isLoading;
  final bool hasError;

  PlaceState({
    this.data,
    this.isLoading = false,
    this.hasError = false,
  });

  PlaceState copyWith({
    List<Place>? places,
    bool? isLoading,
    bool? hasError,
  }) {
    return PlaceState(
      data: places ?? data,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}
