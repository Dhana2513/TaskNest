import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  primaryColorLight: appThemeColor.shade200,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: appThemeColor,
    accentColor: appThemeColor.shade700,
  ),
  useMaterial3: true,
);

final Map<int, Color> _pinkMap = {
  50: const Color(0xFFFF80AB),
  100: const Color(0xFFFF80AB),
  200: const Color(0xFFFF4081),
  300: const Color(0xFFFF4081),
  400: const Color(0xFFF50057),
  500: const Color(0xFFF50057),
  600: const Color(0xFFF50057),
  700: const Color(0xFFC51162),
  800: const Color(0xFFC51162),
  900: const Color(0xFFC51162),
};

MaterialColor appThemeColor = MaterialColor(0xFFFF4081, _pinkMap);
