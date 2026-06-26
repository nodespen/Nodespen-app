import 'package:flutter/material.dart';

class NodespenColors {
  static const Color background = Color(0xFF1A1A2E);
  static const Color surface = Color(0xFF16213E);
  static const Color primary = Color(0xFF0F3460);
  static const Color accent = Color(0xFFE94560);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C0);
  static const Color border = Color(0xFF2A2A4A);
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFD600);
  static const Color error = Color(0xFFFF1744);

  static const Color drawMode = Color(0xFF42A5F5);
  static const Color nodeMode = Color(0xFF66BB6A);
  static const Color gachaMode = Color(0xFFEF5350);
}

class NodespenTheme {
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: NodespenColors.background,
    primaryColor: NodespenColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: NodespenColors.primary,
      secondary: NodespenColors.accent,
      surface: NodespenColors.surface,
      error: NodespenColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: NodespenColors.surface,
      foregroundColor: NodespenColors.textPrimary,
    ),
    cardTheme: CardThemeData(
      color: NodespenColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: NodespenColors.border),
      ),
    ),
    iconTheme: const IconThemeData(color: NodespenColors.textSecondary),
    dividerColor: NodespenColors.border,
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: NodespenColors.textPrimary),
      titleMedium: TextStyle(color: NodespenColors.textPrimary),
      bodyLarge: TextStyle(color: NodespenColors.textPrimary),
      bodyMedium: TextStyle(color: NodespenColors.textSecondary),
      labelSmall: TextStyle(color: NodespenColors.textSecondary),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: NodespenColors.surface,
      contentTextStyle: const TextStyle(color: NodespenColors.textPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    tooltipTheme: TooltipThemeData(
      textStyle: const TextStyle(color: NodespenColors.textPrimary),
      decoration: BoxDecoration(
        color: NodespenColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: NodespenColors.primary,
    colorScheme: const ColorScheme.light(
      primary: NodespenColors.primary,
      secondary: NodespenColors.accent,
    ),
  );
}
