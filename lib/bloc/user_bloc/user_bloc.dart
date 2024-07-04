import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/auth/auth_bloc.dart';
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

  late AuthBloc authBloc;

  UserBloc(this.authBloc) {
    dio.interceptors.add(TokenInterceptor());
  }

  void _updateStream(state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print('controller is closed');
      }
      return;
    }
    if (kDebugMode) print('update user stream');
    controller.sink.add(state);
  }

  Future<AppError> _updateError(Object err) async {
    AppError appError = AppError.fromObjectErr(err);
    _updateStream(UserState.hasError(error: appError));
    if (appError.statusCode == 401) await authBloc.logout();
    return appError;
  }

  void dispose() {
    controller.close();
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
      printError(err: err, method: "getUser");
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
      printError(err: err, method: "updateUser");
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
      printError(err: err, method: "changePicture");
      return _updateError(err);
    }
  }
}
