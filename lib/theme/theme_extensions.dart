import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  bool get isDark =>
      Theme.of(this).brightness == Brightness.dark;

  Color get bgColor =>
      isDark
          ? const Color(0xff050816)
          : const Color(0xffF4F9FF);

  Color get cardColorEx =>
      isDark
          ? const Color(0xff0F172A)
          : Colors.white;

  Color get borderColor =>
      isDark
          ? const Color(0xff1E293B)
          : const Color(0xffD9E4F2);

  Color get textColor =>
      isDark ? Colors.white : Colors.black;

  Color get primaryColorEx =>
      isDark
          ? const Color(0xff00E5FF)
          : const Color(0xff2563EB);
}