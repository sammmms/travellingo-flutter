import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor extends Interceptor {
  Dio dio =
      Dio(BaseOptions(baseUrl: "https://travellingo-backend.netlify.app/api/"));

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";
    options.headers.addAll({"Authorization": "Bearer $token"});
    super.onRequest(options, handler);
  }
}
