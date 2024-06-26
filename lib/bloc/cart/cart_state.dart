import 'package:travellingo/models/cart.dart';

class CartState {
  final Cart? data;
  final bool isLoading;
  final bool hasError;

  CartState({this.data, this.isLoading = false, this.hasError = false});

  CartState copyWith({Cart? cart, bool? isLoading, bool? hasError}) {
    return CartState(
        data: cart ?? data,
        isLoading: isLoading ?? this.isLoading,
        hasError: hasError ?? this.hasError);
  }
}
