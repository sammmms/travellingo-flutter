import 'package:travellingo/utils/app_error.dart';

class AuthState {
  bool isAuthenticated;
  bool isAuthenticating;
  bool hasError;
  String? message;
  AppError? error;

  AuthState({
    this.isAuthenticated = false,
    this.isAuthenticating = false,
    this.hasError = false,
    this.message,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState();
  }

  factory AuthState.isAuthenticated({String? message}) {
    return AuthState(isAuthenticated: true, message: message);
  }

  factory AuthState.isAuthenticating() {
    return AuthState(isAuthenticating: true);
  }

  factory AuthState.hasError({required AppError error}) {
    return AuthState(
      hasError: true,
      error: error,
    );
  }

  AuthState copyWith(
      {bool? isAuthenticated,
      bool? isAuthenticating,
      bool? hasError,
      String? message,
      AppError? error}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      hasError: hasError ?? this.hasError,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }
}
