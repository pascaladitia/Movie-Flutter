import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/di/injection.dart';
import '../core/constants/prefs_keys.dart';
import '../core/storage/prefs_manager.dart';
import '../core/l10n/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../features/onboarding/presentation/view/onboarding_page.dart';
import '../features/settings/presentation/bloc/settings_cubit.dart';
import 'app_shell.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: sl<SettingsCubit>(),
      builder: (context, state) {
        final isOnboardingSeen = sl<PrefsManager>().getBool(PrefsKeys.onboardingSeen);
        return MaterialApp(
          title: 'Movie App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.themeMode,
          locale: state.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: isOnboardingSeen ? const AppShell() : const OnboardingPage(),
        );
      },
    );
  }
}
