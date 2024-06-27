import 'package:travellingo/models/cart.dart';
import 'package:travellingo/utils/app_error.dart';

class CartState {
  final Cart? data;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  CartState(
      {this.data, this.error, this.isLoading = false, this.hasError = false});

  CartState copyWith(
      {Cart? cart, bool? isLoading, bool? hasError, AppError? error}) {
    return CartState(
        data: cart ?? data,
        isLoading: isLoading ?? this.isLoading,
        hasError: hasError ?? this.hasError,
        error: error);
  }

  factory CartState.initial() {
    return CartState();
  }

  factory CartState.hasError({required AppError error}) {
    return CartState(hasError: true, error: error);
  }

  factory CartState.isLoading() {
    return CartState(isLoading: true);
  }
}
