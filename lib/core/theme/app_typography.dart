import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Roboto';

  static TextTheme textTheme(ColorScheme colorScheme) {
    final base = Typography.material2021().black.apply(
      fontFamily: fontFamily,
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontSize: 57, fontWeight: FontWeight.w700, letterSpacing: -0.25),
      displayMedium: base.displayMedium?.copyWith(fontSize: 45, fontWeight: FontWeight.w700),
      displaySmall: base.displaySmall?.copyWith(fontSize: 36, fontWeight: FontWeight.w700),
      headlineLarge: base.headlineLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.w700),
      headlineMedium: base.headlineMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.w700),
      headlineSmall: base.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
      titleLarge: base.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
      titleMedium: base.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
      titleSmall: base.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      bodySmall: base.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      labelLarge: base.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      labelMedium: base.labelMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      labelSmall: base.labelSmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
    );
  }
}
