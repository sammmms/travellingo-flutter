import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:travellingo/pages/profile/notifications/notifications_page.dart';

class Store {
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

  static Future saveNotificationPreferences(
      {required UserNotificationPreference specialTipsAndOffers,
      required UserNotificationPreference activity,
      required UserNotificationPreference reminders}) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> notificationMap = {
      'specialTipsAndOffers': specialTipsAndOffers.toJson(),
      'activity': activity.toJson(),
      'reminders': reminders.toJson()
    };

    String encoded = jsonEncode(notificationMap);
    prefs.setString('notification', encoded);
  }

  static Future<Map<String, UserNotificationPreference>>
      getNotificationPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    String? encoded = prefs.getString('notification');
    if (encoded == null) {
      return {
        'specialTipsAndOffers': UserNotificationPreference(),
        'activity': UserNotificationPreference(),
        'reminders': UserNotificationPreference()
      };
    }
    Map<String, dynamic> notificationMap = jsonDecode(encoded);
    Map<String, UserNotificationPreference> result = {
      'specialTipsAndOffers': UserNotificationPreference.fromJson(
          notificationMap['specialTipsAndOffers']),
      'activity':
          UserNotificationPreference.fromJson(notificationMap['activity']),
      'reminders':
          UserNotificationPreference.fromJson(notificationMap['reminders'])
    };
    return result;
  }

  static Future removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
