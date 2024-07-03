import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/flight/flight_state.dart';
import 'package:travellingo/interceptors/token_interceptor.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/error_print.dart';
import 'package:travellingo/utils/flight_class_util.dart';

class FlightBloc {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
    ),
  );

  final controller = BehaviorSubject<FlightState>.seeded(FlightState.initial());

  FlightBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  void _updateStream(state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print('flight stream is closed');
      }
      return;
    }
    if (kDebugMode) {
      print('update flight stream');
    }
    controller.sink.add(state);
  }

  AppError _updateError(Object err) {
    AppError appError = AppError.fromObjectErr(err);
    _updateStream(FlightState.error(appError));
    return appError;
  }

  void dispose() {
    controller.close();
  }

  Future<void> getFlight({
    required String departure,
    required String arrival,
    required DateTime startDate,
    required FlightClass flightClass,
    DateTime? endDate,
  }) async {
    _updateStream(FlightState.loading());
    try {
      String url =
          '/flight?departure=$departure&arrival=$arrival&startDate=${startDate.toUtc().toIso8601String()}';

      if (endDate != null) {
        url += '&endDate=$endDate';
      }

      String parsedUrl = Uri.parse(url).toString();

      if (kDebugMode) {
        print(parsedUrl);
      }

      var response = await dio.get(parsedUrl);
      var data = response.data as List;

      if (kDebugMode) {
        print(response);
      }

      List<Flight> flights =
          data.map<Flight>((e) => Flight.fromJson(e)).toList();
      _updateStream(FlightState.success(flights));
      return;
    } catch (err) {
      printError(err: err, method: "getFlight");
      _updateError(err);
    }
  }
}
