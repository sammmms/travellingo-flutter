import 'dart:async';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/user_bloc/user_state.dart';
import 'package:travellingo/interceptors/token_interceptor.dart';
import 'package:travellingo/models/user.dart';

class UserBloc {
  StreamController<UserState> controller = BehaviorSubject();
  final dio = Dio();

  /// To get user profile data, needs token
  Future getUser() async {
    try {
      dio.interceptors.add(TokenInterceptor());
      var response = await dio.get(
        "https://travellingo-backend.netlify.app/api/profile",
      );
      var data = response.data;
      controller.add(UserState(receivedProfile: User.fromJson(data)));
    } on DioException catch (err) {
      controller.add(UserState(
        error: true,
        errorMessage: err.response?.data,
        errorStatus: err.response?.statusCode,
      ));
    } catch (err) {
      controller.add(UserState(
        error: true,
        errorMessage: "somethingWrong",
      ));
    }
  }

  Future updateUser(User user) async {
    try {
      dio.interceptors.add(TokenInterceptor());
      controller.add(UserState(loading: true));
      var response = await dio
          .put("https://travellingo-backend.netlify.app/api/profile", data: {
        "name": user.name,
        "email": user.email,
        "phoneNumber": user.phone,
        "gender": user.gender ?? "",
        "id": user.id ?? ""
      });
      var data = response.data;
      controller.add(UserState(receivedMessage: data));
    } on DioException catch (err) {
      controller.add(UserState(
        error: true,
        errorMessage: err.response?.data,
        errorStatus: err.response?.statusCode,
      ));
    } catch (err) {
      controller.add(UserState(
        error: true,
        errorMessage: "somethingWrong",
      ));
    }
  }
}
