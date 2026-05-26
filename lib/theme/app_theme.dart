import 'package:flutter/material.dart';

class AppTheme {
  // ================= LIGHT =================

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xffedf4ff),

    primaryColor: const Color(0xff2563eb),

    fontFamily: 'Roboto',

    colorScheme: const ColorScheme.light(
      primary: Color(0xff2563eb),
      secondary: Color(0xff06b6d4),
    ),

    cardColor: Colors.white,

    dividerColor: Colors.black12,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Color(0xff111827),
      ),
      bodyMedium: TextStyle(
        color: Color(0xff374151),
      ),
      titleLarge: TextStyle(
        color: Color(0xff111827),
        fontWeight: FontWeight.bold,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      hintStyle: TextStyle(
        color: Colors.black.withOpacity(0.45),
      ),

      labelStyle: const TextStyle(
        color: Color(0xff374151),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.08),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.08),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xff06b6d4),
        ),
      ),
    ),
  );

  // ================= DARK =================

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xff030712),

    primaryColor: Colors.cyanAccent,

    fontFamily: 'Roboto',

    colorScheme: const ColorScheme.dark(
      primary: Colors.cyanAccent,
      secondary: Colors.blueAccent,
    ),

    cardColor: const Color(0xff071120),

    dividerColor: Colors.white12,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),

      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.45),
      ),

      labelStyle: TextStyle(
        color: Colors.white.withOpacity(0.7),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.08),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.08),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.cyanAccent,
        ),
      ),
    ),
  );
}