import 'dart:io';

import 'package:dio/dio.dart';

class AppError extends Error {
  final String message;
  final int? statusCode;

  AppError({this.message = "somethingWrong", this.statusCode});

  @override
  String toString() {
    return '$message - $statusCode';
  }

  factory AppError.fromObjectErr(Object err) {
    late AppError appError;
    if (err is DioException) {
      if (err is SocketException) {
        appError = AppError(message: "noInternetConnect", statusCode: 400);
      }
      //
      else {
        appError = AppError(
            message: err.response?.data?.toString() ?? "somethingWrong",
            statusCode: err.response?.statusCode);
      }
    }
    //
    else {
      appError = AppError(message: "somethingWrong");
    }
    return appError;
  }
}
