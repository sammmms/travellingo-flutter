import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: "Poppins",
  indicatorColor: Colors.yellow,
  progressIndicatorTheme:
      ProgressIndicatorThemeData(color: colorSchemeDark.secondary),
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(
      color: Color(0xFFF5D161),
    ),
    color: Color(0xFF1B1B1B),
    titleTextStyle: TextStyle(
        fontFamily: "Poppins",
        color: Colors.white,
        fontSize: 18,
        letterSpacing: 1.1,
        fontWeight: FontWeight.bold),
  ),
  textTheme: textStyleDark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  dialogTheme: const DialogTheme(
    surfaceTintColor: Color(0xFF121212),
  ),
  brightness: Brightness.dark,
  cardTheme: const CardTheme(
    color: Color(0xFF1E1E1E),
    surfaceTintColor: Color(0xFF1E1E1E),
  ),
  bottomSheetTheme:
      const BottomSheetThemeData(surfaceTintColor: Color(0xFF1E1E1E)),
  canvasColor: const Color(0xFF121212),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2C2C2C),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.transparent)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.transparent)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.redAccent)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.redAccent)),
    disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.transparent)),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(colorSchemeDark.primary),
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          side: const WidgetStatePropertyAll(
              BorderSide(color: Colors.transparent)),
          foregroundColor: const WidgetStatePropertyAll(Colors.white))),
  colorScheme: colorSchemeDark,
  iconTheme: IconThemeData(color: colorSchemeDark.primary),
  primaryIconTheme: IconThemeData(color: colorSchemeDark.primary),
  switchTheme: SwitchThemeData(
    thumbColor: const WidgetStatePropertyAll(Colors.white),
    trackColor: WidgetStatePropertyAll(colorSchemeDark.primary),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: colorSchemeDark.secondary),
  useMaterial3: true,
);

TextTheme textStyleDark = TextTheme(
  bodySmall: TextStyle(color: colorSchemeDark.onSurface, fontSize: 10),
  bodyMedium: TextStyle(color: colorSchemeDark.onSurface, fontSize: 12),
  bodyLarge: TextStyle(color: colorSchemeDark.onSurface, fontSize: 14),
  titleSmall: TextStyle(
    color: colorSchemeDark.onSurface,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    color: colorSchemeDark.onSurface,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  ),
  titleLarge: TextStyle(
    color: colorSchemeDark.onSurface,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  displaySmall: TextStyle(color: colorSchemeDark.onSurface, fontSize: 10),
  displayMedium: TextStyle(color: colorSchemeDark.onSurface, fontSize: 12),
  displayLarge: TextStyle(color: colorSchemeDark.onSurface, fontSize: 14),
  headlineSmall: TextStyle(color: colorSchemeDark.onSurface, fontSize: 16),
  headlineMedium: TextStyle(color: colorSchemeDark.onSurface, fontSize: 17),
  headlineLarge: TextStyle(color: colorSchemeDark.onSurface, fontSize: 18),
  labelSmall: TextStyle(color: colorSchemeDark.onSurface, fontSize: 10),
  labelMedium: TextStyle(color: colorSchemeDark.onSurface, fontSize: 12),
  labelLarge: TextStyle(color: colorSchemeDark.onSurface, fontSize: 14),
).apply(fontFamily: 'Poppins');

ColorScheme colorSchemeDark = ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFFF5D161),
    onPrimary: Colors.black,
    primaryContainer: Colors.orangeAccent.shade200,
    secondary: Colors.yellow,
    onSecondary: Colors.black,
    error: Colors.redAccent.shade200,
    onError: Colors.black,
    surface: const Color(0xFF1E1E1E),
    surfaceTint: const Color.fromARGB(255, 59, 59, 59),
    surfaceDim: const Color.fromARGB(255, 63, 63, 63),
    surfaceBright: const Color(0xFF2C2C2C),
    onSurface: const Color(0xFFE0E0E0),
    tertiary: Colors.cyan.shade100,
    tertiaryContainer: Colors.cyan.shade600);
