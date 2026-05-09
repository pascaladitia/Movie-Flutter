import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';

class AppColors {
  AppColors._();

  static const Color primaryRed = Color(0xFFD32F2F);

  static ColorScheme lightScheme() {
    return ColorScheme.fromSeed(
      seedColor: primaryRed,
      brightness: Brightness.light,
    );
  }

  static ColorScheme darkScheme() {
    return ColorScheme.fromSeed(
      seedColor: primaryRed,
      brightness: Brightness.dark,
    );
  }

  static const AppCustomColors lightCustom = AppCustomColors(
    success: Color(0xFF2E7D32),
    warning: Color(0xFFED6C02),
    info: Color(0xFF0288D1),
    border: Color(0x1F000000),
    divider: Color(0x1F000000),
    inputFill: Color(0xFFF5F5F5),
    onImageText: Color(0xFFFFFFFF),
    onImageSubtleText: Color(0xD9FFFFFF),
    imageOverlayTop: Color(0x40000000),
    imageOverlayBottom: Color(0xCC000000),
    indicatorInactive: Color(0x8AFFFFFF),
    posterPlaceholder: Color(0xFFE0E0E0),
    posterPlaceholderShimmer: Color(0xFFF2F2F2),
    avatarBorder: Color(0xB3FFFFFF),
    avatarShadow: Color(0x42000000),
  );

  static const AppCustomColors darkCustom = AppCustomColors(
    success: Color(0xFF81C784),
    warning: Color(0xFFFFB74D),
    info: Color(0xFF4FC3F7),
    border: Color(0x33FFFFFF),
    divider: Color(0x33FFFFFF),
    inputFill: Color(0xFF1F1F1F),
    onImageText: Color(0xFFFFFFFF),
    onImageSubtleText: Color(0xD9FFFFFF),
    imageOverlayTop: Color(0x40000000),
    imageOverlayBottom: Color(0xD9000000),
    indicatorInactive: Color(0x8AFFFFFF),
    posterPlaceholder: Color(0xFF404040),
    posterPlaceholderShimmer: Color(0xFF2E2E2E),
    avatarBorder: Color(0xB3FFFFFF),
    avatarShadow: Color(0x42000000),
  );
}
