import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travellingo/bloc/theme/theme_state.dart';
import 'package:travellingo/models/recent_flight_search.dart';
import 'package:travellingo/pages/profile/notifications/notification_preferences_page.dart';

class Store {
  static Future saveLoginPreferences(
      bool isTicked, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isTicked", isTicked);
    prefs.setBool('haveLoggedIn', true);
    if (isTicked) {
      prefs.setString('email', email);
      prefs.setString('password', password);
    }
  }

  /// Returns a map with keys:
  ///
  /// - isTicked: bool
  ///
  /// - haveLoggedIn: bool
  ///
  /// - email: String
  static Future<Map<String, dynamic>> getLoginPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isTicked = prefs.getBool('isTicked');
    bool? haveLoggedIn = prefs.getBool('haveLoggedIn');
    String? email = prefs.getString('email');
    return {'isTicked': isTicked, 'haveLoggedIn': haveLoggedIn, 'email': email};
  }

  // TOKEN

  static Future saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  static Future removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // NOTIFICATION

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

  // LANGUAGE
  static Future saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', languageCode);
  }

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language');
  }

  // THEME
  static Future<void> saveTheme(ThemeType themeType) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', themeType.toString());
  }

  static Future<ThemeType> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('theme');
    if (theme == null) {
      return ThemeType.light;
    }
    return ThemeType.values
        .firstWhere((element) => element.toString() == theme);
  }

  // HOMEPAGE CITY
  static Future<void> saveChoosenCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('city', city);
  }

  static Future<String?> getChoosenCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('city');
  }

  // RECENT FLIGHT
  static Future<void> saveRecentFlightSearch(
      RecentFlightSearch recentFlightSearch) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentFlightSearchesString =
        prefs.getStringList('recentFlightSearches') ?? [];

    List<RecentFlightSearch> recentFlightSearches = recentFlightSearchesString
        .map((e) => RecentFlightSearch.fromJson(jsonDecode(e)))
        .toList();

    RecentFlightSearch? foundRecentFlight = recentFlightSearches
        .firstWhereOrNull((element) => element.isEqual(recentFlightSearch));

    if (foundRecentFlight != null) {
      recentFlightSearches.remove(foundRecentFlight);
    }

    recentFlightSearches.insert(0, recentFlightSearch);

    if (recentFlightSearches.length > 5) {
      recentFlightSearches.removeLast();
    }

    prefs.setStringList('recentFlightSearches',
        recentFlightSearches.map((e) => jsonEncode(e)).toList());
  }

  static Future<List<RecentFlightSearch>> getRecentFlightSearch() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentFlightSearches =
        prefs.getStringList('recentFlightSearches') ?? [];

    return recentFlightSearches
        .map((e) => RecentFlightSearch.fromJson(jsonDecode(e)))
        .toList();
  }

  static Future<void> clearRecentFlightSearch() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('recentFlightSearches');
  }
}
