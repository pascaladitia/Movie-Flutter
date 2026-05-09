import 'package:flutter/material.dart';

@immutable
class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color success;
  final Color warning;
  final Color info;
  final Color border;
  final Color divider;
  final Color inputFill;
  final Color onImageText;
  final Color onImageSubtleText;
  final Color imageOverlayTop;
  final Color imageOverlayBottom;
  final Color indicatorInactive;
  final Color posterPlaceholder;
  final Color posterPlaceholderShimmer;
  final Color avatarBorder;
  final Color avatarShadow;

  const AppCustomColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.border,
    required this.divider,
    required this.inputFill,
    required this.onImageText,
    required this.onImageSubtleText,
    required this.imageOverlayTop,
    required this.imageOverlayBottom,
    required this.indicatorInactive,
    required this.posterPlaceholder,
    required this.posterPlaceholderShimmer,
    required this.avatarBorder,
    required this.avatarShadow,
  });

  @override
  AppCustomColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? border,
    Color? divider,
    Color? inputFill,
    Color? onImageText,
    Color? onImageSubtleText,
    Color? imageOverlayTop,
    Color? imageOverlayBottom,
    Color? indicatorInactive,
    Color? posterPlaceholder,
    Color? posterPlaceholderShimmer,
    Color? avatarBorder,
    Color? avatarShadow,
  }) {
    return AppCustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      inputFill: inputFill ?? this.inputFill,
      onImageText: onImageText ?? this.onImageText,
      onImageSubtleText: onImageSubtleText ?? this.onImageSubtleText,
      imageOverlayTop: imageOverlayTop ?? this.imageOverlayTop,
      imageOverlayBottom: imageOverlayBottom ?? this.imageOverlayBottom,
      indicatorInactive: indicatorInactive ?? this.indicatorInactive,
      posterPlaceholder: posterPlaceholder ?? this.posterPlaceholder,
      posterPlaceholderShimmer: posterPlaceholderShimmer ?? this.posterPlaceholderShimmer,
      avatarBorder: avatarBorder ?? this.avatarBorder,
      avatarShadow: avatarShadow ?? this.avatarShadow,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      onImageText: Color.lerp(onImageText, other.onImageText, t)!,
      onImageSubtleText: Color.lerp(onImageSubtleText, other.onImageSubtleText, t)!,
      imageOverlayTop: Color.lerp(imageOverlayTop, other.imageOverlayTop, t)!,
      imageOverlayBottom: Color.lerp(imageOverlayBottom, other.imageOverlayBottom, t)!,
      indicatorInactive: Color.lerp(indicatorInactive, other.indicatorInactive, t)!,
      posterPlaceholder: Color.lerp(posterPlaceholder, other.posterPlaceholder, t)!,
      posterPlaceholderShimmer: Color.lerp(posterPlaceholderShimmer, other.posterPlaceholderShimmer, t)!,
      avatarBorder: Color.lerp(avatarBorder, other.avatarBorder, t)!,
      avatarShadow: Color.lerp(avatarShadow, other.avatarShadow, t)!,
    );
  }
}
