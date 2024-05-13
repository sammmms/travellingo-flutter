import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travellingo/bloc/auth_bloc/auth_state.dart';
import 'package:travellingo/bloc/preferences/save_preferences.dart';

class AuthBloc {
  final StreamController<AuthState> controller = StreamController();
  final dio = Dio();

  Future signIn(BuildContext context, String email, String password) async {
    try {
      controller.add(AuthState(isSubmitting: true));
      var response = await dio.post(
          "https://travellingo-backend.netlify.app/api/login",
          data: {"email": email, "password": password});
      var token = response.data["token"];
      if (context.mounted) {
        bool rememberMeState = context.read<bool>();
        SavePreferences.saveLoginPreferences(
            rememberMeState, email, password, token);
      }
      controller.add(AuthState(receivedToken: token));
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

  Future signUp(BuildContext context, String name, String email,
      String password, String birthday, String phoneNumber) async {
    try {
      controller.add(AuthState(isSubmitting: true));
      var response = await dio
          .post("https://travellingo-backend.netlify.app/api/register", data: {
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
