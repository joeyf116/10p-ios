import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    const background = Color(0xFFF8F9FA);
    const surface = Color(0xFFFFFFFF);
    const textPrimary = Color(0xFF212529);
    const textSecondary = Color(0xFF6C757D);
    const border = Color(0xFFDEE2E6);

    final scheme = ColorScheme.fromSeed(
      seedColor: textPrimary,
      brightness: Brightness.light,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        surface: surface,
        onSurface: textPrimary,
        outline: border,
      ),
      scaffoldBackgroundColor: background,
      dividerColor: border,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        bodySmall: TextStyle(color: textSecondary),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
      ),
    );
  }

  static ThemeData get dark {
    const background = Color(0xFF121212);
    const surface = Color(0xFF1E1E1E);
    const textPrimary = Color(0xFFF8F9FA);
    const textSecondary = Color(0xFFA6A6A6);
    const border = Color(0xFF2D2D2D);

    final scheme = ColorScheme.fromSeed(
      seedColor: textPrimary,
      brightness: Brightness.dark,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        surface: surface,
        onSurface: textPrimary,
        outline: border,
      ),
      scaffoldBackgroundColor: background,
      dividerColor: border,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        bodySmall: TextStyle(color: textSecondary),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
      ),
    );
  }
}
