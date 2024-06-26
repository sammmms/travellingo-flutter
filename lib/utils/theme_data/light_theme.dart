import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: "Poppins",
  indicatorColor: Colors.yellow,
  progressIndicatorTheme:
      ProgressIndicatorThemeData(color: colorScheme.secondary),
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(
      color: Color(0xFFF5D161),
    ),
    color: Colors.white,
    titleTextStyle: TextStyle(
        fontFamily: "Poppins",
        color: Colors.black,
        fontSize: 18,
        letterSpacing: 1.1,
        fontWeight: FontWeight.bold),
  ),
  textTheme: textStyle,
  scaffoldBackgroundColor: Colors.white,
  dialogTheme: const DialogTheme(
    surfaceTintColor: Colors.white,
  ),
  brightness: Brightness.light,
  cardTheme: const CardTheme(
    color: Colors.white,
    surfaceTintColor: Colors.white,
  ),
  bottomSheetTheme: const BottomSheetThemeData(surfaceTintColor: Colors.white),
  canvasColor: Colors.white,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF6F8FB),
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
          backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          side: const WidgetStatePropertyAll(
              BorderSide(color: Colors.transparent)),
          foregroundColor: const WidgetStatePropertyAll(Colors.white))),
  colorScheme: ColorScheme.fromSeed(seedColor: colorScheme.primary),
  iconTheme: IconThemeData(color: colorScheme.primary),
  primaryIconTheme: IconThemeData(color: colorScheme.primary),
  switchTheme: SwitchThemeData(
    thumbColor: const WidgetStatePropertyAll(Colors.white),
    trackColor: WidgetStatePropertyAll(colorScheme.primary),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white, selectedItemColor: colorScheme.secondary),
  useMaterial3: true,
);

TextTheme textStyle = TextTheme(
  bodySmall: TextStyle(color: colorScheme.onSurface, fontSize: 10),
  bodyMedium: TextStyle(color: colorScheme.onSurface, fontSize: 12),
  bodyLarge: TextStyle(color: colorScheme.onSurface, fontSize: 14),
  titleSmall: TextStyle(
    color: colorScheme.onSurface,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    color: colorScheme.onSurface,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  ),
  titleLarge: TextStyle(
    color: colorScheme.onSurface,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  displaySmall: TextStyle(color: colorScheme.onSurface, fontSize: 10),
  displayMedium: TextStyle(color: colorScheme.onSurface, fontSize: 12),
  displayLarge: TextStyle(color: colorScheme.onSurface, fontSize: 14),
  headlineSmall: TextStyle(color: colorScheme.onSurface, fontSize: 16),
  headlineMedium: TextStyle(color: colorScheme.onSurface, fontSize: 17),
  headlineLarge: TextStyle(color: colorScheme.onSurface, fontSize: 18),
  labelSmall: TextStyle(color: colorScheme.onSurface, fontSize: 10),
  labelMedium: TextStyle(color: colorScheme.onSurface, fontSize: 12),
  labelLarge: TextStyle(color: colorScheme.onSurface, fontSize: 14),
).apply(fontFamily: 'Poppins');

ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: const Color(0xFFF5D161),
  onPrimary: Colors.white,
  primaryContainer: Colors.orangeAccent.shade200,
  secondary: Colors.yellow,
  onSecondary: Colors.white,
  error: Colors.redAccent.shade200,
  onError: Colors.white,
  inverseSurface: const Color(0xAA1B1446),
  surface: Colors.white,
  onSurface: const Color.fromRGBO(27, 20, 70, 1),
);
