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
}
