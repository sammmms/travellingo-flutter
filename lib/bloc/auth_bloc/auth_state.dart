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
}
