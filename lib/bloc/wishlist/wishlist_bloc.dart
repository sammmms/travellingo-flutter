import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/wishlist/wishlist_state.dart';
import 'package:travellingo/interceptors/token_interceptor.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/error_print.dart';
import 'package:travellingo/utils/place_category_util.dart';

class WishlistBloc {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));

  final controller =
      BehaviorSubject<WishlistState>.seeded(WishlistState.initial());

  late AuthBloc authBloc;

  WishlistBloc(this.authBloc) {
    dio.interceptors.add(TokenInterceptor());
  }

  void _updateStream(WishlistState state) {
    if (controller.isClosed) {
      if (kDebugMode) print("controller is closed");
      return;
    }
    if (kDebugMode) print("updated wishlist state");
    controller.add(state);
  }

  AppError _updateError(Object err) {
    AppError error = AppError.fromObjectErr(err);
    _updateStream(WishlistState.error(error));
    return error;
  }

  Future getWishlist(
      {String? id, PlaceCategory? category, String? search}) async {
    try {
      _updateStream(WishlistState.loading());

      String url = "/wishlist";

      if (id != null) {
        url += "/$id";
      }

      List<String> query = [];

      if (category != null && category != PlaceCategory.all) {
        query.add("type=${PlaceCategoryUtil.stringOf(category)}");
      }

      if (search != null) {
        query.add("search=$search");
      }

      if (query.isNotEmpty) {
        url += "?${query.join("&")}";
      }

      final response = await dio.get(url);

      var data = response.data;

      if (kDebugMode) print(data);

      List<Place> places = [];
      if (data['items'] is List) {
        List items = data['items'];
        places = items.map((e) => Place.fromJson(e['place'])).toList();
      } else {
        places = [Place.fromJson(data['place'])];
      }

      _updateStream(WishlistState.success(places));
    } catch (err) {
      printError(err: err, method: "getWishlist");
      _updateError(err);
    }
  }
}
