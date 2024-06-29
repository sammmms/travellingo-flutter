import 'package:travellingo/models/transaction.dart';
import 'package:travellingo/utils/app_error.dart';

class TransactionState {
  final List<Transaction>? transactions;
  final bool isLoading;
  final bool hasError;
  final AppError? error;

  TransactionState({
    this.transactions,
    this.isLoading = false,
    this.hasError = false,
    this.error,
  });

  factory TransactionState.initial() {
    return TransactionState();
  }

  factory TransactionState.hasError({required AppError error}) {
    return TransactionState(hasError: true, error: error);
  }

  factory TransactionState.isLoading() {
    return TransactionState(isLoading: true);
  }

  TransactionState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    bool? hasError,
    AppError? error,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      error: error ?? this.error,
    );
  }
}
