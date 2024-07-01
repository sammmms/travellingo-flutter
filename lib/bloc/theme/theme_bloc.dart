import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/theme/theme_state.dart';
import 'package:travellingo/utils/store.dart';

class ThemeBloc {
  final BehaviorSubject<ThemeState> _controller =
      BehaviorSubject<ThemeState>.seeded(ThemeState.initial());

  Stream<ThemeState> get themeStream => _controller.stream;
  ThemeState get currentTheme => _controller.value;

  void _updateStream(ThemeState state) {
    if (_controller.isClosed) {
      if (kDebugMode) {
        print('Controller is closed');
      }
      return;
    }
    if (kDebugMode) {
      print("update theme stream : ${state.themeType}");
    }
    _controller.add(state);
  }

  void dispose() {
    _controller.close();
  }

  void toggleTheme() {
    if (currentTheme.themeType == ThemeType.light) {
      _updateStream(ThemeState(themeType: ThemeType.dark));
      Store.saveTheme(ThemeType.dark);
    } else {
      _updateStream(ThemeState(themeType: ThemeType.light));
      Store.saveTheme(ThemeType.light);
    }
  }

  Future<void> initThemeStream() async {
    ThemeType themeType = await Store.getTheme();
    _updateStream(ThemeState(themeType: themeType));
  }
}
