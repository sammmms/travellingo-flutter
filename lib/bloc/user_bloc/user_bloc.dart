import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/user_bloc/user_state.dart';
import 'package:travellingo/interceptors/token_interceptor.dart';
import 'package:travellingo/models/user.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/error_print.dart';

class UserBloc {
  final controller = BehaviorSubject<UserState>();
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
    ),
  );

  UserBloc() {
    dio.interceptors.add(TokenInterceptor());
  }

  void _updateStream(state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print('controller is closed');
      }
      return;
    }
    controller.sink.add(state);
  }

  AppError _updateError(Object err) {
    late AppError appError;
    if (err is DioException) {
      appError = AppError(
          message: err.response?.data, statusCode: err.response?.statusCode);
      _updateStream(UserState.hasError(error: appError));
    }
    appError = AppError(message: 'somethingWrong');
    _updateStream(UserState.hasError(error: appError));
    return appError;
  }

  Future<AppError?> getUser() async {
    try {
      _updateStream(UserState.isLoading());

      var response = await dio.get("/profile");
      var data = response.data;

      User user = User.fromJson(data);

      _updateStream(UserState.updateProfile(user: user));
      return null;
    } catch (err) {
      printError(err: err);
      return _updateError(err);
    }
  }

  Future<AppError?> updateUser(User user) async {
    try {
      _updateStream(UserState.isLoading());

      var response = await dio.put("/profile", data: {
        "name": user.name,
        "email": user.email,
        "phoneNumber": user.phone,
        "gender": user.gender ?? "",
        "id": user.id ?? ""
      });
      var data = response.data;

      User receivedUser = User.fromJson(data["user"]);

      _updateStream(
        UserState(
          receivedMessage: data['message'],
          receivedProfile: receivedUser,
        ),
      );

      return null;
    } catch (err) {
      printError(err: err);
      return _updateError(err);
    }
  }

  Future<AppError?> changePicture(String base64encode) async {
    try {
      _updateStream(UserState.isLoading());

      var response =
          await dio.put("/profile/picture", data: {"picture": base64encode});
      var data = response.data;

      if (kDebugMode) print("manage to update picture");
      var user = User.fromJson(data["user"]);

      controller.add(
          UserState(receivedProfile: user, receivedMessage: data['message']));

      return null;
    } catch (err) {
      printError(err: err);
      return _updateError(err);
    }
  }
}
