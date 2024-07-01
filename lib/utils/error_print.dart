import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

void printError({required Object err, String? method}) {
  if (kDebugMode) {
    if (err is DioException) {
      print("error on $method : dio");
      print(err.response);
      return;
    }
    print("error on $method : platform");
    print(err);
  }
}
