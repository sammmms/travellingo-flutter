import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/transaction/transaction_state.dart';
import 'package:travellingo/interceptors/token_interceptor.dart';
import 'package:travellingo/models/transaction.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/error_print.dart';

class TransactionBloc {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));

  final controller =
      BehaviorSubject<TransactionState>.seeded(TransactionState.initial());

  Stream<TransactionState> get state => controller;

  TransactionBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  void dispose() {
    controller.close();
  }

  void _updateStream(TransactionState state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print('Controller is closed');
      }
      return;
    }
    if (kDebugMode) {
      print("update transaction stream");
    }
    controller.add(state);
  }

  AppError _updateError(Object err) {
    late AppError appError;
    if (err is DioException) {
      if (err is SocketException) {
        appError = AppError(message: "noInternetConnect", statusCode: 400);
      } else {
        appError = AppError(
            message: err.response?.data?.toString() ?? "somethingWrong",
            statusCode: err.response?.statusCode);
      }
    } else {
      appError = AppError(message: "somethingWrong");
    }
    _updateStream(TransactionState.hasError(error: appError));
    return appError;
  }

  Future<void> getTransaction() async {
    controller.add(TransactionState.isLoading());
    try {
      final response = await dio.get('/transaction');

      var data = response.data;

      if (kDebugMode) {
        print(data);
      }

      List<Transaction> transactions = data
          .map<Transaction>((transaction) => Transaction.fromJson(transaction))
          .toList();

      _updateStream(TransactionState(transactions: transactions));
    } catch (err) {
      printError(err: err, method: "getTransaction");
      _updateError(err);
    }
  }
}
