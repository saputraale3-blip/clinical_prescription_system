import 'package:flutter/material.dart';

class AppColors {
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness ==
        Brightness.dark;
  }

  static Color background(BuildContext context) {
    return isDark(context)
        ? const Color(0xff030712)
        : const Color(0xfff1f5f9);
  }

  static Color card(BuildContext context) {
    return isDark(context)
        ? Colors.white.withOpacity(0.05)
        : Colors.white.withOpacity(0.85);
  }

  static Color border(BuildContext context) {
    return isDark(context)
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.08);
  }

  static Color text(BuildContext context) {
    return isDark(context)
        ? Colors.white
        : const Color(0xff0f172a);
  }

  static Color subText(BuildContext context) {
    return isDark(context)
        ? Colors.white70
        : Colors.black54;
  }

  static Color field(BuildContext context) {
    return isDark(context)
        ? Colors.white.withOpacity(0.04)
        : Colors.white;
  }
}