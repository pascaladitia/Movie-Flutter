import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/prefs_manager.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsState({required this.themeMode, required this.locale});

  SettingsState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object> get props => [themeMode, locale];
}

class SettingsCubit extends Cubit<SettingsState> {
  static const _themeModeKey = 'themeMode';
  static const _localeCodeKey = 'localeCode';
  final PrefsManager prefsManager;

  SettingsCubit(this.prefsManager)
      : super(const SettingsState(themeMode: ThemeMode.system, locale: Locale('en')));

  Future<void> init() async {
    await prefsManager.init();
    final theme = prefsManager.getString(_themeModeKey, defaultValue: 'system');
    final localeCode = prefsManager.getString(_localeCodeKey, defaultValue: 'en');

    emit(
      state.copyWith(
        themeMode: _themeFromString(theme),
        locale: Locale(localeCode),
      ),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await prefsManager.setString(_themeModeKey, mode.name);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setLocale(Locale locale) async {
    await prefsManager.setString(_localeCodeKey, locale.languageCode);
    emit(state.copyWith(locale: locale));
  }

  ThemeMode _themeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
