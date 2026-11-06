import 'package:flutter/material.dart';

/// Colours in one place. Provisional farm greens and browns: the San Diego County Farm Bureau's
/// exact colours aren't confirmed yet; swap them here once they are.
abstract final class Brand {
  static const green = Color(0xFF2E6B3A);
  static const greenDark = Color(0xFF1D4A28);
  static const earth = Color(0xFF7A5230);
  static const wheat = Color(0xFFC98A2F);
  static const paper = Color(0xFFF6F3E9);

  /// Set to e.g. 'assets/brand/logo.png' (and list it in pubspec.yaml) once there's a file.
  static const String? eventLogoAsset = null;
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: Brand.green,
    primary: Brand.green,
    secondary: Brand.earth,
    surface: Brand.paper,
  );
  return ThemeData(
    colorScheme: scheme,
    fontFamily: 'Atkinson',
    scaffoldBackgroundColor: Brand.paper,
    appBarTheme: const AppBarTheme(
      backgroundColor: Brand.green,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontFamily: 'Atkinson',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
  );
}
