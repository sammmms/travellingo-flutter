import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/place/place_state.dart';
import 'package:travellingo/models/place.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/place_category_util.dart';

class PlaceBloc {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
    ),
  );
  final controller = BehaviorSubject<PlaceState>();

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
        print(url);
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
      _updateStream(PlaceState(hasError: true));
      if (err is DioException) {
        if (kDebugMode) {
          print('error on get place : dio');
          print(err);
        }
        return AppError(err.response?.data,
            code: err.response?.statusCode.toString());
      }
      if (kDebugMode) {
        print('error on get place : platform');
        print(err);
      }
      return AppError("somethingWrong");
    }
  }
}
