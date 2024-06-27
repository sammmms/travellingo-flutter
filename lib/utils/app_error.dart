class AppError extends Error {
  final String message;
  final int? statusCode;

  AppError({required this.message, this.statusCode});

  @override
  String toString() {
    return 'AppError: $message';
  }
}
