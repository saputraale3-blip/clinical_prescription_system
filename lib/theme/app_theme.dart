import 'package:flutter/material.dart';

class AppTheme {

  // =========================
  // DARK THEME
  // =========================

  static ThemeData darkTheme =
      ThemeData(

    brightness: Brightness.dark,

    scaffoldBackgroundColor:
        const Color(0xFF0F172A),

    primaryColor:
        Colors.cyan,

    appBarTheme:
        const AppBarTheme(

      backgroundColor:
          Color(0xFF0F172A),

      elevation: 0,

      centerTitle: false,
    ),

    cardColor:
        const Color(0xFF1E293B),

    colorScheme:
        const ColorScheme.dark(

      primary:
          Colors.cyan,
    ),

    inputDecorationTheme:
        InputDecorationTheme(

      filled: true,

      fillColor:
          const Color(0xFF334155),

      border:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        borderSide:
            BorderSide.none,
      ),
    ),

    elevatedButtonTheme:
        ElevatedButtonThemeData(

      style:
          ElevatedButton.styleFrom(

        backgroundColor:
            Colors.cyan,

        foregroundColor:
            Colors.white,

        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),

        minimumSize:
            const Size(
          double.infinity,
          55,
        ),
      ),
    ),
  );

  // =========================
  // LIGHT THEME
  // =========================

  static ThemeData lightTheme =
      ThemeData(

    brightness: Brightness.light,

    scaffoldBackgroundColor:
        Colors.grey.shade100,

    primaryColor:
        Colors.blue,

    appBarTheme:
        AppBarTheme(

      backgroundColor:
          Colors.white,

      foregroundColor:
          Colors.black,

      elevation: 0,
    ),

    cardColor:
        Colors.white,

    colorScheme:
        const ColorScheme.light(

      primary:
          Colors.blue,
    ),

    inputDecorationTheme:
        InputDecorationTheme(

      filled: true,

      fillColor:
          Colors.white,

      border:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        borderSide:
            BorderSide.none,
      ),
    ),

    elevatedButtonTheme:
        ElevatedButtonThemeData(

      style:
          ElevatedButton.styleFrom(

        backgroundColor:
            Colors.blue,

        foregroundColor:
            Colors.white,

        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),

        minimumSize:
            const Size(
          double.infinity,
          55,
        ),
      ),
    ),
  );
}