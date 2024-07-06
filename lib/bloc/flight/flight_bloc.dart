import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
import 'package:travellingo/bloc/flight/flight_state.dart';
import 'package:travellingo/bloc/mopay/mopay_bloc.dart';
import 'package:travellingo/interceptors/token_interceptor.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/models/passenger.dart';
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

  late AuthBloc authBloc;

  FlightBloc(this.authBloc) {
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

  Future<AppError> _updateError(Object err) async {
    AppError appError = AppError.fromObjectErr(err);
    _updateStream(FlightState.error(error: appError));
    if (appError.statusCode == 401) await authBloc.logout();
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

  Future<dynamic> bookFlight({
    required Flight flight,
    required List<Passenger> passengers,
    required String phoneNumber,
    int? additionalPayment,
  }) async {
    try {
      _updateStream(FlightState.loading());

      var mopayUserId =
          await MopayBloc().getMopayIdByPhoneNumber("0$phoneNumber");

      if (mopayUserId is AppError) {
        return _updateError(mopayUserId);
      }

      Map<String, dynamic> data = {
        'passengers': passengers.map((e) => e.toJson()).toList(),
        'mopayUserId': mopayUserId,
        if (additionalPayment != null) 'additionalPayment': additionalPayment,
      };

      if (kDebugMode) {
        print(data);
      }

      String url = '/flight/${flight.id}/book';

      if (kDebugMode) {
        print(url);
      }

      var response = await dio.post(url, data: data);

      if (kDebugMode) {
        print(response);
      }

      return response.data;
    } catch (err) {
      printError(err: err, method: "bookFlight");
      return _updateError(err);
    }
  }
}
