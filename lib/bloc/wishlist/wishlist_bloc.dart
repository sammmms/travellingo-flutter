import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/wishlist/wishlist_state.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/error_print.dart';

class WishlistBloc {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));

  final controller =
      BehaviorSubject<WishlistState>.seeded(WishlistState.initial());

  void _updateStream(WishlistState state) {
    if (controller.isClosed) {
      if (kDebugMode) print("controller is closed");
      return;
    }
    if (kDebugMode) print("updated cart state");
    controller.add(state);
  }

  AppError _updateError(Object err) {
    AppError error = AppError.fromObjectErr(err);
    _updateStream(WishlistState.error(error));
    return error;
  }

  Future getWishlist() async {
    try {
      _updateStream(WishlistState.loading());
      final response = await dio.get('/wishlist');

      var data = response.data;

      if (kDebugMode) print(data);

      List<Place> places =
          data.map<Place>((place) => Place.fromJson(place)).toList();

      _updateStream(WishlistState.success(places));
    } catch (err) {
      printError(err: err, method: "getWishlist");
      _updateError(err);
    }
  }
}
