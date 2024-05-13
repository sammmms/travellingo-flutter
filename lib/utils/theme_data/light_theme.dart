import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: "Poppins",
  indicatorColor: Colors.yellow,
  progressIndicatorTheme:
      const ProgressIndicatorThemeData(color: Colors.yellow),
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
          backgroundColor: const MaterialStatePropertyAll(Color(0xFFF5D161)),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          side: const MaterialStatePropertyAll(
              BorderSide(color: Colors.transparent)),
          foregroundColor: const MaterialStatePropertyAll(Colors.white))),
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF5D161)),
  iconTheme: const IconThemeData(color: Color(0xFFF5D161)),
  primaryIconTheme: const IconThemeData(color: Color(0xFFF5D161)),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white, selectedItemColor: Color(0xFFF5D161)),
  textTheme: const TextTheme().apply(
      bodyColor: const Color(0xAA1B1446),
      displayColor: const Color(0xAA1B1446)),
  useMaterial3: true,
);
