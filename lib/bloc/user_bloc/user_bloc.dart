import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/user_bloc/user_state.dart';
import 'package:travellingo/interceptors/token_interceptor.dart';
import 'package:travellingo/models/user.dart';
import 'package:travellingo/utils/app_error.dart';

class UserBloc {
  final controller = BehaviorSubject<UserState>();
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
    ),
  );

  void _updateStream(state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print('controller is closed');
      }
      return;
    }
    controller.sink.add(state);
  }

  /// To get user profile data, needs token
  Future getUser() async {
    try {
      dio.interceptors.add(TokenInterceptor());
      var response = await dio.get("/profile");
      var data = response.data;
      _updateStream(UserState(receivedProfile: User.fromJson(data)));
      return true;
    } on DioException catch (err) {
      _updateStream(UserState(error: true));

      return AppError(err.response?.data,
          code: err.response?.statusCode.toString());
    } catch (err) {
      _updateStream(UserState(error: true));
      if (kDebugMode) {
        print("error on get user : platform");
        print(err);
      }
      return AppError("somethingWrong");
    }
  }

  Future updateUser(User user) async {
    try {
      dio.interceptors.add(TokenInterceptor());
      controller.add(UserState(loading: true));
      var response = await dio.put("/profile", data: {
        "name": user.name,
        "email": user.email,
        "phoneNumber": user.phone,
        "gender": user.gender ?? "",
        "id": user.id ?? ""
      });
      var data = response.data;

      User receivedUser = User.fromJson(data["user"]);

      _updateStream(UserState(
          receivedMessage: data['message'], receivedProfile: receivedUser));
      return true;
    } on DioException catch (err) {
      _updateStream(UserState(error: true));
      if (kDebugMode) {
        print("error on update user : dio");
        print(err.response);
      }
      return AppError(err.response?.data,
          code: err.response?.statusCode.toString());
    } catch (err) {
      _updateStream(UserState(error: true));
      if (kDebugMode) {
        print("error on update user : platform");
        print(err);
      }
      return AppError("somethingWrong");
    }
  }

  Future changePicture(String base64encode) async {
    try {
      dio.interceptors.add(TokenInterceptor());
      controller.add(UserState(loading: true));
      var response =
          await dio.put("/profile/picture", data: {"picture": base64encode});
      var data = response.data;

      if (kDebugMode) print("manage to update picture");
      var user = User.fromJson(data["user"]);

      controller.add(
          UserState(receivedProfile: user, receivedMessage: data['message']));

      return true;
    } on DioException catch (err) {
      _updateStream(UserState(error: true));
      if (kDebugMode) {
        print("error on change picture : dio");
        print(err.response);
      }
      return AppError(err.response?.data,
          code: err.response?.statusCode.toString());
    } catch (err) {
      _updateStream(UserState(error: true));
      if (kDebugMode) {
        print("error on change picture : platform");
        print(err);
      }
      return AppError("somethingWrong");
    }
  }
}
