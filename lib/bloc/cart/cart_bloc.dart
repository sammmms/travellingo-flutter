import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/cart/cart_state.dart';
import 'package:travellingo/interceptors/token_interceptor.dart';
import 'package:travellingo/models/cart.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/error_print.dart';

class CartBloc {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));
  final controller = BehaviorSubject<CartState>();

  CartBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  void _updateStream(CartState state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print("failed to update cart stream: stream is closed");
      }
      return;
    }
    if (kDebugMode) {
      print("update cart stream");
    }
    controller.add(state);
  }

  AppError _updateError(Object err) {
    AppError error = AppError.fromObjectErr(err);
    _updateStream(CartState.hasError(error: error));
    return error;
  }

  void dispose() {
    controller.close();
  }

  Future getCart([needLoading = true]) async {
    try {
      _updateStream(CartState(isLoading: needLoading));

      var response = await dio.get('/cart');
      var responseData = response.data;

      if (kDebugMode) {
        print(response);
      }

      var cart = Cart.fromJson(responseData);

      _updateStream(CartState(data: cart));
    } catch (err) {
      printError(err: err, method: "getCart");
      _updateError(err);
    }
  }

  Future<AppError?> updateItemQuantity(String placeId, int quantity) async {
    try {
      var response =
          await dio.put('/cart/$placeId', data: {'quantity': quantity});

      if (response.statusCode == 201) {
        getCart(false);
        return null;
      }

      return _updateError(AppError(message: "somethingWrong"));
    } catch (err) {
      printError(err: err);
      return _updateError(err);
    }
  }
}
