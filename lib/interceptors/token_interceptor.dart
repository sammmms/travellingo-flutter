import 'package:dio/dio.dart';
import 'package:travellingo/utils/store.dart';

class TokenInterceptor extends Interceptor {
  Dio dio =
      Dio(BaseOptions(baseUrl: "https://travellingo-backend.netlify.app/api/"));

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await Store.getToken();
    options.headers.addAll({"Authorization": "Bearer $token"});
    super.onRequest(options, handler);
  }
}
