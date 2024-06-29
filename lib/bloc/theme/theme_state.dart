enum ThemeType { light, dark }

class ThemeState {
  final ThemeType themeType;

  ThemeState({required this.themeType});

  factory ThemeState.initial() {
    return ThemeState(themeType: ThemeType.light);
  }
}
