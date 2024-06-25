class AuthState {
  String? receivedToken;
  bool isSubmitting;
  bool error;
  String? errorMessage;
  int? errorStatus;
  String? successMessage;

  AuthState({
    this.receivedToken,
    this.errorMessage,
    this.errorStatus,
    this.isSubmitting = false,
    this.error = false,
    this.successMessage,
  });

  AuthState copyWith({
    String? receivedToken,
    bool? isSubmitting,
    bool? error,
    String? errorMessage,
    int? errorStatus,
    String? successMessage,
  }) {
    return AuthState(
      receivedToken: receivedToken ?? this.receivedToken,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
      errorStatus: errorStatus ?? this.errorStatus,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
