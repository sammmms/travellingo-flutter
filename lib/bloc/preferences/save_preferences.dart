import 'package:shared_preferences/shared_preferences.dart';

class SavePreferences {
  static Future saveLoginPreferences(
      bool isTicked, String email, String password, String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isTicked", isTicked);
    prefs.setBool('haveLoggedIn', true);
    prefs.setString('email_authenticate', email);
    prefs.setString('password_authenticate', password);
    saveToken(token);
    switch (isTicked) {
      case true:
        prefs.setString('email', email);
        prefs.setString('password', password);
        prefs.setString('savedToken', token);
      default:
        prefs.remove('email');
        prefs.remove('password');
        prefs.remove('savedToken');
    }
  }

  static Future saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
}
