import 'package:shared_preferences/shared_preferences.dart';

class ResetPreferences {
  static Future removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
