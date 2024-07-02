import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/place/place_state.dart';
import 'package:travellingo/interceptors/token_interceptor.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/error_print.dart';
import 'package:travellingo/utils/place_category_util.dart';

class PlaceBloc {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
    ),
  );
  final controller = BehaviorSubject<PlaceState>.seeded(PlaceState.initial());

  PlaceBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  void _updateStream(state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print('place stream is closed');
      }
      return;
    }

    if (kDebugMode) {
      print('update place stream');
    }
    controller.sink.add(state);
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
    _updateStream(PlaceState.hasError(error: appError));
    return appError;
  }

  void dispose() {
    controller.close();
  }

  Future<AppError?> getPlace({String? search, PlaceCategory? filter}) async {
    try {
      _updateStream(PlaceState(isLoading: true));

      String url = "/places";

      if (filter != null && filter != PlaceCategory.all) {
        {
          url += "?category=${PlaceCategoryUtil.stringOf(filter)}";
        }
      }

      if (search != null && search.isNotEmpty) {
        if (filter != null && filter != PlaceCategory.all) {
          url += "&search=$search";
        } else {
          url += "?search=$search";
        }
      }

      if (kDebugMode) {
        print("${dotenv.env["BASE_URL"]}$url");
      }

      var response = await dio.get(url);
      if (kDebugMode) {
        print(response.data);
      }
      List data = response.data;
      List<Place> places = data.map((place) => Place.fromJson(place)).toList();

      _updateStream(PlaceState(data: places));
      return null;
    } catch (err) {
      printError(err: err, method: "getPlace");
      return _updateError(err);
    }
  }

  Future<AppError?> getPlaceById(String id) async {
    try {
      _updateStream(PlaceState(isLoading: true));

      var response = await dio.get("/places/$id");
      if (kDebugMode) {
        print(response.data);
      }
      Place place = Place.fromJson(response.data);

      _updateStream(PlaceState(data: [place]));
      return null;
    } catch (err) {
      printError(err: err, method: "getPlaceById");
      return _updateError(err);
    }
  }

  Future<AppError?> createPlace(Place place) async {
    try {
      _updateStream(PlaceState(isLoading: true));

      var response = await dio.post("/places", data: place.toJson());
      if (kDebugMode) {
        print(response.data);
      }
      Place newPlace = Place.fromJson(response.data);

      _updateStream(PlaceState(data: [newPlace]));
      return null;
    } catch (err) {
      printError(err: err, method: "createPlace");
      return _updateError(err);
    }
  }

  Future<AppError?> updatePlace(Place place) async {
    try {
      _updateStream(PlaceState.isLoading());

      var response = await dio.put("/places/${place.id}", data: place.toJson());
      if (kDebugMode) {
        print(response.data);
      }
      Place updatedPlace = Place.fromJson(response.data);

      _updateStream(PlaceState(data: [updatedPlace]));
      return null;
    } catch (err) {
      printError(err: err, method: "updatePlace");
      return _updateError(err);
    }
  }

  Future<AppError?> deletePlace(String id) async {
    try {
      _updateStream(PlaceState.isLoading());

      await dio.delete("/places/$id");

      return null;
    } catch (err) {
      printError(err: err, method: "deletePlace");
      return _updateError(err);
    }
  }

  Future<AppError?> addToCart(String id, int quantity) async {
    try {
      _updateStream(PlaceState.isLoading());

      await dio.post(
        "/place/$id/cart",
        data: {"quantity": quantity},
      );

      return null;
    } catch (err) {
      printError(err: err, method: "addToCart");
      return _updateError(err);
    }
  }

  Future<AppError?> addToWishlist(String id) async {
    try {
      _updateStream(PlaceState.isLoading());

      await dio.post(
        "/place/$id/wishlist",
      );

      return null;
    } catch (err) {
      printError(err: err, method: "addToWishlist");
      return _updateError(err);
    }
  }
}
