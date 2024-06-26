class AuthState {
  String? receivedToken;
  bool isSubmitting;
  bool hasError;
  String? errorMessage;
  int? errorStatus;
  String? successMessage;

  AuthState({
    this.receivedToken,
    this.errorMessage,
    this.errorStatus,
    this.isSubmitting = false,
    this.hasError = false,
    this.successMessage,
  });

  AuthState copyWith({
    String? receivedToken,
    bool? isSubmitting,
    bool? hasError,
    String? errorMessage,
    int? errorStatus,
    String? successMessage,
  }) {
    return AuthState(
      receivedToken: receivedToken ?? this.receivedToken,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      errorStatus: errorStatus ?? this.errorStatus,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
