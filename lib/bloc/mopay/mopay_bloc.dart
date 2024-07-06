import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travellingo/utils/app_error.dart';
import 'package:travellingo/utils/error_print.dart';

class MopayBloc {
  final dio = Dio(
    BaseOptions(
      baseUrl:
          '${dotenv.env['BASE_URL']!.substring(0, dotenv.env['BASE_URL']!.lastIndexOf('/travellingo'))}/mopay',
    ),
  );

  Future<dynamic> getMopayIdByPhoneNumber(String phoneNumber) async {
    try {
      final response =
          await dio.get('/profile/public?phoneNumber=$phoneNumber');
      return response.data["_id"];
    } catch (err) {
      printError(err: err, method: 'getMopayIdByPhoneNumber');
      return AppError.fromObjectErr(err);
    }
  }
}
