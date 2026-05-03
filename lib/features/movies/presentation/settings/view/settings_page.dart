import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../../settings/presentation/bloc/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = sl<SettingsCubit>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        bloc: cubit,
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.theme, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<ThemeMode>(
                initialValue: state.themeMode,
                items: [
                  DropdownMenuItem(value: ThemeMode.system, child: Text(l10n.system)),
                  DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.light)),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.dark)),
                ],
                onChanged: (value) {
                  if (value != null) cubit.setThemeMode(value);
                },
              ),
              const SizedBox(height: 24),
              Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<Locale>(
                initialValue: state.locale,
                items: const [
                  DropdownMenuItem(value: Locale('en'), child: Text('English')),
                  DropdownMenuItem(value: Locale('id'), child: Text('Indonesia')),
                ],
                onChanged: (value) {
                  if (value != null) cubit.setLocale(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
