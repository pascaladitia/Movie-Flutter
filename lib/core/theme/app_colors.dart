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
