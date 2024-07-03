import 'package:travellingo/models/flight.dart';
import 'package:travellingo/utils/app_error.dart';

class FlightState {
  final List<Flight>? flights;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  FlightState({
    this.flights,
    this.isLoading = false,
    this.hasError = false,
    this.error,
  });

  factory FlightState.initial() => FlightState();

  factory FlightState.loading() => FlightState(isLoading: true);

  factory FlightState.error([AppError? error]) =>
      FlightState(hasError: true, error: error);

  factory FlightState.success(List<Flight>? flights) =>
      FlightState(flights: flights);
}
