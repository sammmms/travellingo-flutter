class AppError extends Error {
  final String message;
  final int? statusCode;

  AppError({this.message = "somethingWrong", this.statusCode});

  @override
  String toString() {
    return '$message - $statusCode';
  }
}
