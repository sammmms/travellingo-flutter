import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
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

  late AuthBloc authBloc;

  PlaceBloc(this.authBloc) {
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

  Future<AppError> _updateError(Object err) async {
    AppError appError = AppError.fromObjectErr(err);
    _updateStream(PlaceState.hasError(error: appError));
    if (appError.statusCode == 401) await authBloc.logout();
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
