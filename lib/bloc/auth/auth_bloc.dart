import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/auth/auth_state.dart';
import 'package:travellingo/bloc/user_bloc/user_bloc.dart';
import 'package:travellingo/interceptors/token_interceptor.dart';
import 'package:travellingo/utils/error_print.dart';
import 'package:travellingo/utils/store.dart';
import 'package:travellingo/utils/app_error.dart';

class AuthBloc {
  final BehaviorSubject<AuthState> controller =
      BehaviorSubject<AuthState>.seeded(AuthState.initial());

  late UserBloc userBloc;

  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_URL']!,
  ));

  AuthBloc(this.userBloc) {
    dio.interceptors.add(TokenInterceptor());
  }

  void _updateStream(AuthState state) {
    if (controller.isClosed) {
      if (kDebugMode) {
        print("controller is closed");
      }
      return;
    }
    if (kDebugMode) {
      print("add state to auth stream");
    }
    controller.add(state);
  }

  AppError _updateError(Object err) {
    AppError error = AppError.fromObjectErr(err);
    _updateStream(AuthState.hasError(error: error));
    return error;
  }

  void dispose() {
    controller.close();
  }

  Future<AppError?> login(
      BuildContext context, String email, String password) async {
    try {
      _updateStream(AuthState.isAuthenticating());
      // POST LOGIN
      var response = await dio
          .post("/login", data: {"email": email, "password": password});
      var token = response.data["token"];

      // SAVE TOKEN
      Store.saveToken(token);

      userBloc.getUser();

      _updateStream(AuthState.isAuthenticated());
      return null;
    } catch (err) {
      printError(err: err, method: "signIn");
      return _updateError(err);
    }
  }

  Future<AppError?> register(BuildContext context, String name, String email,
      String password, String birthday, String phoneNumber) async {
    try {
      _updateStream(AuthState.isAuthenticating());

      var response = await dio.post("/register", data: {
        "name": name,
        "email": email,
        "password": password,
        "birthday": birthday,
        "phoneNumber": phoneNumber
      });

      _updateStream(AuthState.isAuthenticated(message: response.data));
      return null;
    } catch (err) {
      printError(err: err, method: "signUp");
      return _updateError(err);
    }
  }

  Future checkLogin() async {
    String? token = await Store.getToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      if (decodedToken['exp'] > DateTime.now().millisecondsSinceEpoch / 1000) {
        userBloc.getUser();
        return _updateStream(AuthState.isAuthenticated());
      }
    }
    Store.removeToken();
    return _updateStream(AuthState.initial());
  }

  Future logout() async {
    await Store.removeToken();
    return _updateStream(AuthState.initial());
  }
}
