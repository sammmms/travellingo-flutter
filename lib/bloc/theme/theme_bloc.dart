import 'package:rxdart/rxdart.dart';
import 'package:travellingo/bloc/theme/theme_state.dart';

class ThemeBloc {
  final BehaviorSubject<ThemeState> _controller =
      BehaviorSubject<ThemeState>.seeded(ThemeState.initial());

  Stream<ThemeState> get themeStream => _controller.stream;
  ThemeState get currentTheme => _controller.value;

  void _updateStream(ThemeState state) {
    if (_controller.isClosed) {
      return;
    }
    _controller.add(state);
  }

  void dispose() {
    _controller.close();
  }

  void toggleTheme() {
    if (currentTheme.themeType == ThemeType.light) {
      _updateStream(ThemeState(themeType: ThemeType.dark));
    } else {
      _updateStream(ThemeState(themeType: ThemeType.light));
    }
  }
}