import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
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

  final AuthBloc authBloc;

  TransactionBloc(this.authBloc) {
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

  Future<AppError> _updateError(Object err) async {
    AppError appError = AppError.fromObjectErr(err);
    _updateStream(TransactionState.hasError(error: appError));
    if (appError.statusCode == 401) await authBloc.logout();
    return appError;
  }

  Future<void> getTransaction([TransactionType? type]) async {
    _updateStream(TransactionState.isLoading());
    try {
      String url = '/transaction';

      if (type != null && type != TransactionType.all) {
        url += '?type=${TransactionTypeUtil.textOf(type)}';
      }

      final response = await dio.get(url);

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

  Future getMopayId(String phoneNumber) async {
    try {
      _updateStream(TransactionState.isLoading());
      final response = await Dio().get(
          "https://travellingo-backend.netlify.app/api/mopay/profile/public?phoneNumber=$phoneNumber");

      return response.data["_id"];
    } catch (err) {
      printError(err: err, method: "getMopayId");
      return _updateError(err);
    }
  }

  Future checkoutCart(
      {required List<String> itemsId,
      required String mopayId,
      int? additionalPayment}) async {
    try {
      _updateStream(TransactionState.isLoading());
      Map<String, dynamic> payloadData = {
        "checkoutItem": jsonEncode(itemsId),
        "mopayUserId": mopayId,
        if (additionalPayment != null) "additionalPayment": additionalPayment,
      };
      var response = await dio.post("/cart/checkout", data: payloadData);

      _updateStream(TransactionState.initial());
      return response.data;
    } catch (err) {
      if (err is DioException && err.response?.statusCode == 402) {
        return err.response?.data;
      }
      printError(err: err, method: "checkoutCart");
      return _updateError(err);
    }
  }
}
