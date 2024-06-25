import 'package:flutter/material.dart';
import 'package:travellingo/utils/theme_data/color_scheme.dart';

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
  textTheme: textTheme,
  scaffoldBackgroundColor: Colors.white,
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
          backgroundColor: MaterialStatePropertyAll(colorScheme.primary),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          side: const MaterialStatePropertyAll(
              BorderSide(color: Colors.transparent)),
          foregroundColor: const MaterialStatePropertyAll(Colors.white))),
  colorScheme: ColorScheme.fromSeed(seedColor: colorScheme.primary),
  iconTheme: IconThemeData(color: colorScheme.primary),
  primaryIconTheme: IconThemeData(color: colorScheme.primary),
  switchTheme: SwitchThemeData(
    thumbColor: const MaterialStatePropertyAll(Colors.white),
    trackColor: MaterialStatePropertyAll(colorScheme.primary),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white, selectedItemColor: colorScheme.primary),
  useMaterial3: true,
);

TextTheme textTheme = TextTheme(
  bodySmall: TextStyle(color: colorScheme.onSurface, fontSize: 10),
  bodyMedium: TextStyle(color: colorScheme.onSurface, fontSize: 12),
  bodyLarge: TextStyle(color: colorScheme.onSurface, fontSize: 14),
  titleSmall: TextStyle(
    color: colorScheme.onBackground,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    color: colorScheme.onBackground,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  ),
  titleLarge: TextStyle(
    color: colorScheme.onBackground,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  displaySmall: TextStyle(color: colorScheme.onSurface, fontSize: 10),
  displayMedium: TextStyle(color: colorScheme.onSurface, fontSize: 12),
  displayLarge: TextStyle(color: colorScheme.onSurface, fontSize: 14),
  headlineSmall: TextStyle(color: colorScheme.onSurface, fontSize: 10),
  headlineMedium: TextStyle(color: colorScheme.onSurface, fontSize: 12),
  headlineLarge: TextStyle(color: colorScheme.onSurface, fontSize: 14),
  labelSmall: TextStyle(color: colorScheme.onSurface, fontSize: 10),
  labelMedium: TextStyle(color: colorScheme.onSurface, fontSize: 12),
  labelLarge: TextStyle(color: colorScheme.onSurface, fontSize: 14),
).apply(fontFamily: 'Poppins');
