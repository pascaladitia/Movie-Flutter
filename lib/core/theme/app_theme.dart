import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final scheme = AppColors.lightScheme();
    final custom = AppColors.lightCustom;
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      colorScheme: scheme,
      textTheme: AppTypography.textTheme(scheme),
      scaffoldBackgroundColor: scheme.surface,
      extensions: <ThemeExtension<dynamic>>[custom],
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.onSurface,
          textStyle: AppTypography.textTheme(scheme).labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          textStyle: AppTypography.textTheme(scheme).titleMedium,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(AppTypography.textTheme(scheme).labelMedium),
      ),
      appBarTheme: AppBarTheme(centerTitle: false, backgroundColor: scheme.surface, elevation: 0),
    );
  }

  static ThemeData get dark {
    final scheme = AppColors.darkScheme();
    final custom = AppColors.darkCustom;
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      colorScheme: scheme,
      textTheme: AppTypography.textTheme(scheme),
      scaffoldBackgroundColor: scheme.surface,
      extensions: <ThemeExtension<dynamic>>[custom],
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.onSurface,
          textStyle: AppTypography.textTheme(scheme).labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          textStyle: AppTypography.textTheme(scheme).titleMedium,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(AppTypography.textTheme(scheme).labelMedium),
      ),
      appBarTheme: AppBarTheme(centerTitle: false, backgroundColor: scheme.surface, elevation: 0),
    );
  }
}
