import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travellingo/bloc/auth/auth_state.dart';
import 'package:travellingo/bloc/preferences/save_preferences.dart';
import 'package:travellingo/utils/app_error.dart';

class AuthBloc {
  final StreamController<AuthState> controller = StreamController();
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_URL']!,
  ));

  Future signIn(BuildContext context, String email, String password) async {
    try {
      controller.add(AuthState(isSubmitting: true));
      var response = await dio
          .post("/login", data: {"email": email, "password": password});
      var token = response.data["token"];
      if (context.mounted) {
        bool rememberMeState = context.read<bool>();
        Store.saveLoginPreferences(rememberMeState, email, password, token);
      }
      controller.add(AuthState(receivedToken: token));
      return true;
    } on DioException catch (err) {
      controller.add(AuthState(
        error: true,
        errorMessage: err.response?.data,
        errorStatus: err.response?.statusCode,
      ));
      throw AppError(
        err.response?.data ?? "somethingWrong",
        code: err.response?.statusCode.toString(),
      );
    } catch (err) {
      controller.add(AuthState(
        error: true,
        errorMessage: "somethingWrong",
      ));
      throw AppError(
        "somethingWrong",
      );
    }
  }

  Future signUp(BuildContext context, String name, String email,
      String password, String birthday, String phoneNumber) async {
    try {
      controller.add(AuthState(isSubmitting: true));
      var response = await dio.post("/register", data: {
        "name": name,
        "email": email,
        "password": password,
        "birthday": birthday,
        "phoneNumber": phoneNumber
      });
      controller.add(AuthState(successMessage: response.data));
      return true;
    } on DioException catch (err) {
      controller.add(AuthState(
        error: true,
        errorMessage: err.response?.data,
        errorStatus: err.response?.statusCode,
      ));
    } catch (err) {
      controller.add(AuthState(
        error: true,
        errorMessage: "somethingWrong",
      ));
    }
  }

  Future checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      if (decodedToken['exp'] > DateTime.now().millisecondsSinceEpoch / 1000) {
        return controller.add(AuthState(receivedToken: token));
      }
    }
    return controller.add(AuthState());
  }
}