import 'package:travellingo/models/place.dart';

class PlaceState {
  final List<Place>? data;
  final bool isLoading;
  final bool isError;

  PlaceState({
    this.data,
    this.isLoading = false,
    this.isError = false,
  });

  PlaceState copyWith({
    List<Place>? places,
    bool? isLoading,
    bool? isError,
  }) {
    return PlaceState(
      data: places ?? data,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }
}
