import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/review/review_state.dart';
import 'package:travellingo/interceptors/token_interceptor.dart';
import 'package:travellingo/models/review.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/error_print.dart';

class ReviewBloc {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env["BASE_URL"]!,
  ));

  final controller = BehaviorSubject<ReviewState>.seeded(ReviewState.initial());
  late AuthBloc authBloc;

  ReviewBloc(this.authBloc) {
    dio.interceptors.add(TokenInterceptor());
  }

  void _updateStream(ReviewState state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print("ReviewBloc is closed");
      }
      return;
    }
    if (kDebugMode) {
      print("updated review bloc state");
    }
    controller.add(state);
  }

  Future<AppError> _updateError(Object err) async {
    AppError appError = AppError.fromObjectErr(err);
    _updateStream(ReviewState.error(appError));
    if (appError.statusCode == 401) await authBloc.logout();
    return appError;
  }

  Future<void> getReview() async {
    try {
      var response = await dio.get("/review");
      var responseData = response.data;

      if (kDebugMode) {
        print(response);
      }

      List<Review> reviews = responseData.map<Review>((review) {
        return Review.fromJson(review);
      }).toList();

      _updateStream(ReviewState.success(reviews));
    } catch (err) {
      printError(err: err, method: "getReview");
      await _updateError(err);
    }
  }
}
